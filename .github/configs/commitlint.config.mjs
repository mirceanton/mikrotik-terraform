// Extending the conventional commit rules
export default {
  extends: ["@commitlint/config-conventional"],
  rules: {
    // Enforce specific commit types
    "type-enum": [
      2, // Error level
      "always",
      [
        "feat", // New feature
        "fix", // Bug fix
        "docs", // Documentation changes
        "style", // Formatting, whitespace, missing semicolons, etc.
        "refactor", // Code restructuring without functional changes
        "perf", // Performance improvements
        "test", // Adding or modifying tests
        "chore", // Changes to build process or auxiliary tools
        "ci", // Continuous Integration changes
        "revert", // Reverting a previous commit
      ],
    ],
    // Enforce case style for commit messages
    "subject-case": [
      2, // Error level
      "always",
      [
        "sentence-case", // Example: "Fix login button issue"
        "start-case", // Example: "Fix Login Button Issue"
        "lower-case", // Example: "fix login button issue"
      ],
    ],
  },
};