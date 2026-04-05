#!/usr/bin/env python3
# /// script
# requires-python = ">=3.11"
# dependencies = ["jinja2"]
# ///
"""Parses a Terragrunt plan output file and generates a structured markdown comment.

Usage: generate-plan-comment.py [plan_file] [output_file] [template_name]
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
LINE_RE = re.compile(r"^\S+ \S+ \[(?P<unit>[^\]]+)\] (?:tofu: )?(?P<content>.*)$")

PLAN_SUMMARY_RE = re.compile(
    r"Plan: (?P<add>\d+) to add, (?P<change>\d+) to change, (?P<destroy>\d+) to destroy"
)


@dataclass
class UnitStats:
    name: str
    lines: list[str] = field(default_factory=list)
    add: int | str = "-"
    change: int | str = "-"
    destroy: int | str = "-"

    @property
    def display_name(self) -> str:
        return self.name.removeprefix("infrastructure/")

    @property
    def status(self) -> str:
        if self.add == "-":
            return "❓"
        if self.add == 0 and self.change == 0 and self.destroy == 0:
            return "✅"
        return "⚠️"

    @property
    def status_line(self) -> str:
        if self.status == "✅":
            return "**Status:** ✅ No changes"
        if self.status == "⚠️":
            return f"**Status:** ⚠️ Changes — **+{self.add}** add / **~{self.change}** change / **-{self.destroy}** destroy"
        return "**Status:** ❓ Unknown (check raw output)"

    @property
    def plan_output(self) -> str:
        return "\n".join(self.lines)


def parse(plan_file: Path) -> list[UnitStats]:
    unit_map: dict[str, UnitStats] = {}
    units: list[UnitStats] = []

    for raw_line in plan_file.read_text().splitlines():
        # Extract the ordered unit list from Terragrunt's header section.
        if m := re.match(r"^- Unit (.+)$", raw_line):
            stat = UnitStats(name=m.group(1))
            units.append(stat)
            unit_map[stat.name] = stat
            continue

        # Parse per-unit output lines.
        if m := LINE_RE.match(raw_line):
            unit_name, content = m.group("unit"), m.group("content")
            if unit_name not in unit_map:
                continue
            stat = unit_map[unit_name]
            stat.lines.append(content)

            if summary := PLAN_SUMMARY_RE.search(content):
                stat.add = int(summary.group("add"))
                stat.change = int(summary.group("change"))
                stat.destroy = int(summary.group("destroy"))
            elif "No changes." in content:
                stat.add = 0
                stat.change = 0
                stat.destroy = 0

    return units


def render(units: list[UnitStats], plan_file: Path, template_name: str = "plan-comment.j2") -> str:
    env = Environment(
        loader=FileSystemLoader(Path(__file__).parent),
        trim_blocks=True,
        lstrip_blocks=True,
        keep_trailing_newline=True,
    )
    return env.get_template(template_name).render(
        units=units,
        raw_output=plan_file.read_text(),
        env=os.environ,
    )


def main() -> None:
    plan_file = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("plan_output.txt")
    output_file = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("comment_body.txt")
    template_name = sys.argv[3] if len(sys.argv) > 3 else "plan-comment.j2"

    units = parse(plan_file)

    if not units:
        print("WARNING: no units found in plan output, falling back to raw output", file=sys.stderr)

    output_file.write_text(render(units, plan_file, template_name))


if __name__ == "__main__":
    main()
