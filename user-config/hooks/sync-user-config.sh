#!/usr/bin/env bash
# Hook SessionStart : copie la config Claude Code du scope user (~/.claude)
# vers le dépôt personal-custom-claude/user-config (sens unique : ~/.claude -> dépôt).
# Puis commit et push de user-config/
SRC="$HOME/.claude"
DEST="/c/Users/Maki/formation-ia/personal-custom-claude/user-config"

FILES=(CLAUDE.md settings.json statusline-command.sh)
DIRS=(skills commands agents hooks)

mkdir -p "$DEST"

for f in "${FILES[@]}"; do
  [ -f "$SRC/$f" ] && cp -f "$SRC/$f" "$DEST/$f"
done

# Dossiers en miroir : la copie est vidée puis recréée (suppressions répercutées)
for d in "${DIRS[@]}"; do
  if [ -d "$SRC/$d" ]; then
    rm -rf "${DEST:?}/$d"
    cp -r "$SRC/$d" "$DEST/$d"
    # skills/synced = skills Anthropic gérés automatiquement, pas des skills perso
    [ "$d" = skills ] && rm -rf "$DEST/skills/synced"
  else
    rm -rf "${DEST:?}/$d"
  fi
done

# Commit + push (uniquement user-config/ ; sans effet s'il n'y a aucun changement)
REPO="$(dirname "$DEST")"
git -C "$REPO" add -A -- user-config
if ! git -C "$REPO" diff --cached --quiet -- user-config; then
  git -C "$REPO" commit -q -m "Synchronise la configuration user de Claude Code" -- user-config     && git -C "$REPO" push -q origin HEAD
fi
exit 0
