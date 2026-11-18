# Gitignore templates

Each section title is `## <Category>: <Name>`. The content of the code block is copied as is.

## Common: OS

```
.DS_Store
Thumbs.db
desktop.ini
```

## Language: Python

```
__pycache__/
*.py[cod]
*.egg-info/
build/
dist/
.venv/
venv/
.env
.pytest_cache/
.coverage
htmlcov/
.mypy_cache/
```

## Language: JavaScript/TypeScript

```
node_modules/
dist/
build/
coverage/
*.log
.env
.env.local
*.tsbuildinfo
```

## Language: Java

```
*.class
*.jar
*.war
hs_err_pid*
.env
```

## Language: Go

```
*.exe
*.test
*.out
vendor/
.env
```

## Language: C#

```
bin/
obj/
*.user
*.suo
.vs/
.env
```

## Framework: Flask

```
instance/
*.sqlite
*.sqlite3
*.db
.webassets-cache
```

## Framework: Django

```
*.sqlite3
db.sqlite3
media/
staticfiles/
local_settings.py
```

## Framework: Node

```
.npm/
.eslintcache
```

## Framework: React

```
.eslintcache
.cache/
```

## Framework: Next.js

```
.next/
out/
.vercel
```

## Framework: Maven

```
target/
pom.xml.tag
pom.xml.releaseBackup
```

## Framework: Gradle

```
.gradle/
build/
!gradle/wrapper/gradle-wrapper.jar
```

## Editor: VS Code

```
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json
*.code-workspace
```

## Editor: JetBrains

```
.idea/
*.iml
*.iws
out/
```

## Editor: Vim

```
*.swp
*.swo
*~
Session.vim
.netrwhist
```

## Editor: Visual Studio

```
.vs/
*.suo
*.user
*.userosscache
```
