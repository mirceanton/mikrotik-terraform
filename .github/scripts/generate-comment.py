#!/usr/bin/env python3
# /// script
# requires-python = ">=3.11"
# dependencies = ["jinja2"]
# ///
"""Parses a Terragrunt plan/apply output file and generates a structured markdown comment.

Usage: generate-comment.py [input_file] [output_file] [mode]
  mode: plan (default), apply, drift
"""

import os
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

from jinja2 import Environment, FileSystemLoader

# Matches: "HH:MM:SS.mmm STDOUT [unit/path] tofu: <content>"
#          "HH:MM:SS.mmm STDERR [unit/path] tofu: <content>"
#          "HH:MM:SS.mmm STDOUT [unit/path] <content>"  (no tofu prefix)
LINE_RE = re.compile(r"^\S+ (?:STDOUT|STDERR) \[(?P<unit>[^\]]+)\] (?:tofu: )?(?P<content>.*)$")

PLAN_SUMMARY_RE = re.compile(
    r"Plan: (?P<add>\d+) to add, (?P<change>\d+) to change, (?P<destroy>\d+) to destroy"
)
APPLY_SUMMARY_RE = re.compile(
    r"Apply complete! Resources: (?P<add>\d+) added, (?P<change>\d+) changed, (?P<destroy>\d+) destroyed\."
)


# GitHub rejects comment/issue bodies over 65,536 characters; stay safely below that.
MAX_BODY_CHARS = 60_000
# Per-unit line budgets to try, in order, until the rendered body fits.
LINE_BUDGETS = (None, 400, 200, 100, 50, 20, 10, 4)


def clip(lines: list[str], max_lines: int | None) -> list[str]:
    """Keep the head and tail of `lines` (plan diff and summary), dropping the middle."""
    if max_lines is None or len(lines) <= max_lines:
        return lines
    head = max_lines // 2
    tail = max_lines - head
    omitted = len(lines) - max_lines
    marker = f"... {omitted} lines omitted, see the workflow run for the full output ..."
    return [*lines[:head], marker, *lines[len(lines) - tail :]]


@dataclass
class UnitStats:
    name: str
    mode: str
    lines: list[str] = field(default_factory=list)
    add: int | str = "-"
    change: int | str = "-"
    destroy: int | str = "-"
    max_lines: int | None = None

    @property
    def display_name(self) -> str:
        return self.name.removeprefix("infrastructure/")

    @property
    def status(self) -> str:
        if self.add == "-":
            return "❓"
        if self.add == 0 and self.change == 0 and self.destroy == 0:
            return "✅"
        return "🚀" if self.mode == "apply" else "⚠️"

    @property
    def status_line(self) -> str:
        if self.status == "✅":
            return "**Status:** ✅ No changes"
        if self.status == "🚀":
            return f"**Status:** 🚀 Applied — **+{self.add}** add / **~{self.change}** change / **-{self.destroy}** destroy"
        if self.status == "⚠️":
            return f"**Status:** ⚠️ Changes — **+{self.add}** add / **~{self.change}** change / **-{self.destroy}** destroy"
        return "**Status:** ❓ Unknown (check raw output)"

    @property
    def output(self) -> str:
        return "\n".join(clip(self.lines, self.max_lines))


def parse(input_file: Path, mode: str) -> list[UnitStats]:
    unit_map: dict[str, UnitStats] = {}
    units: list[UnitStats] = []

    for raw_line in input_file.read_text().splitlines():
        # Discover units from the per-line prefix rather than Terragrunt's header listing,
        # whose format changes between releases. Units are ordered by first appearance.
        if m := LINE_RE.match(raw_line):
            unit_name, content = m.group("unit"), m.group("content")
            if unit_name not in unit_map:
                stat = UnitStats(name=unit_name, mode=mode)
                units.append(stat)
                unit_map[unit_name] = stat
            stat = unit_map[unit_name]
            stat.lines.append(content)

            if summary := PLAN_SUMMARY_RE.search(content):
                stat.add = int(summary.group("add"))
                stat.change = int(summary.group("change"))
                stat.destroy = int(summary.group("destroy"))
            elif summary := APPLY_SUMMARY_RE.search(content):
                stat.add = int(summary.group("add"))
                stat.change = int(summary.group("change"))
                stat.destroy = int(summary.group("destroy"))
            elif "No changes." in content:
                stat.add = 0
                stat.change = 0
                stat.destroy = 0

    return units


def render(units: list[UnitStats], input_file: Path, mode: str) -> str:
    env = Environment(
        loader=FileSystemLoader(Path(__file__).parent),
        trim_blocks=True,
        lstrip_blocks=True,
        keep_trailing_newline=True,
    )
    template = env.get_template("comment.j2")
    raw_lines = input_file.read_text().splitlines()

    body = ""
    for max_lines in LINE_BUDGETS:
        for unit in units:
            unit.max_lines = max_lines
        body = template.render(
            units=units,
            raw_output="\n".join(clip(raw_lines, max_lines)),
            mode=mode,
            env=os.environ,
        )
        if len(body) <= MAX_BODY_CHARS:
            break
    return body


def main() -> None:
    input_file = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("output.txt")
    output_file = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("comment_body.txt")
    mode = sys.argv[3] if len(sys.argv) > 3 else "plan"

    units = parse(input_file, mode)

    if not units:
        print("WARNING: no units found in output, falling back to raw output", file=sys.stderr)

    output_file.write_text(render(units, input_file, mode))


if __name__ == "__main__":
    main()
