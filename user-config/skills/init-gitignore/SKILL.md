---
name: init-gitignore
description: Create a .gitignore for the current project from the language, framework and editor in use. Use when the user asks to initialize, generate or create a .gitignore.
---

# init-gitignore

Generate a `.gitignore` at the repository root from built-in templates.

## Steps

1. Ask the user the three questions below in a **single** AskUserQuestion call
   (multiple-choice with the listed options; the user can always pick "Other"):
   - **Language**: Python, JavaScript/TypeScript, Java, Go, C#
   - **Framework**: depends on the language (Python: Flask, Django; JS/TS: Node, React, Next.js; Java: Maven, Gradle; Go/C#: None), plus "None"
   - **Editor**: VS Code, JetBrains (IntelliJ/PyCharm), Vim, Visual Studio

   Offer at most 4 options per question; put the most common ones first.

2. Read `templates.md` (same folder as this file). Each `## <Category>: <Name>` section is
   the single source of patterns for that value. Select the sections matching the answers,
   plus `## Common: OS` (always included).

3. If an answer is not covered by `templates.md`, do not invent patterns: tell the user that
   value is not supported yet and ask whether to skip it or stop.

4. If a `.gitignore` already exists at the repository root, ask the user whether to
   **overwrite**, **merge** (append only missing patterns, keep existing ones) or **cancel**.
   Never change it before the answer.

5. Write the file: one block per selected section, each preceded by a `# <Name>` comment,
   no duplicate patterns across blocks.

6. Report the file path and the sections included.

## Maintenance

To support a new language, framework or editor, add a section to `templates.md` and list it
in step 1. Do not copy patterns into this file.
