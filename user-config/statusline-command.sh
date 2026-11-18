#!/usr/bin/env bash
# Claude Code status line (single line, truecolor):
# repo | (branch) | context bar + emoji + % | cost | +added -removed | model
input=$(cat)

# --- Input parsing (jq, with a crude sed fallback) ---
if command -v jq >/dev/null 2>&1; then
  jqv() { printf '%s' "$input" | jq -r "$1 // empty"; }
  model=$(jqv '.model.display_name')
  dir=$(jqv '(.workspace.current_dir // .cwd)')
  used=$(jqv '.rate_limits.five_hour.used_percentage')
  cost=$(jqv '.cost.total_cost_usd')
  added=$(jqv '.cost.total_lines_added')
  removed=$(jqv '.cost.total_lines_removed')
else
  sedstr() { printf '%s' "$input" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\(\([^\"\\\\]\|\\\\.\)*\)\".*/\1/p" | head -n1; }
  sednum() { printf '%s' "$input" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\(-\{0,1\}[0-9.]\{1,\}\).*/\1/p" | head -n1; }
  model=$(sedstr display_name)
  dir=$(sedstr current_dir)
  [ -z "$dir" ] && dir=$(sedstr cwd)
  used=$(printf '%s' "$input" | sed -n 's/.*"five_hour"[^}]*"used_percentage"[[:space:]]*:[[:space:]]*\([0-9.]*\).*/\1/p' | head -n1)
  cost=$(sednum total_cost_usd)
  added=$(sednum total_lines_added)
  removed=$(sednum total_lines_removed)
fi

# Normalize Windows separators (raw or JSON-escaped) to forward slashes.
dir=$(printf '%s' "$dir" | sed 's#\\\\#/#g; s#\\#/#g')

# --- Repo and branch ---
repo=""
branch=""
if [ -n "$dir" ] && git -C "$dir" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  top=$(git -C "$dir" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
  [ -n "$top" ] && repo=$(basename "$top")
  branch=$(git -C "$dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi
[ -z "$repo" ] && [ -n "$dir" ] && repo=$(basename "$dir" 2>/dev/null)

# --- Color helpers ---
RST=$'\033[0m'
BOLD=$'\033[1m'
fg() { printf '\033[38;2;%s;%s;%sm' "$1" "$2" "$3"; }

# Gradient green(0,200,80) -> yellow(220,200,0) -> red(220,40,20); $1 = 0..100.
grad() {
  local p=$1 r g b
  if [ "$p" -le 50 ]; then
    r=$((220 * p / 50)); g=200; b=$((80 - 80 * p / 50))
  else
    r=220; g=$((200 - 160 * (p - 50) / 50)); b=$((20 * (p - 50) / 50))
  fi
  fg "$r" "$g" "$b"
}

SEP=" $(fg 90 90 90)|${RST} "
parts=()

[ -n "$repo" ] && parts+=("${BOLD}$(fg 255 220 0)${repo}${RST}")
[ -n "$branch" ] && parts+=("${BOLD}$(fg 0 220 220)🌿 (${branch})${RST}")

# --- 5-hour rate limit bar (20 blocks) ---
if [ -n "$used" ]; then
  pct=${used%%.*}
  [ -z "$pct" ] && pct=0
  [ "$pct" -gt 100 ] && pct=100
  width=20
  filled=$((pct * width / 100))
  bar=""
  for ((i = 0; i < width; i++)); do
    if [ "$i" -lt "$filled" ]; then
      bar+="$(grad $((i * 100 / (width - 1))))█"
    else
      bar+="$(fg 60 60 60)█"
    fi
  done
  if [ "$pct" -ge 90 ]; then emoji="🚨"
  elif [ "$pct" -ge 70 ]; then emoji="🔥"
  elif [ "$pct" -ge 20 ]; then emoji="⚡"
  else emoji="🟢"; fi
  parts+=("${emoji} 5h ${bar}${RST} $(grad "$pct")${pct}%${RST}")
fi

# --- Session cost ---
[ -n "$cost" ] && parts+=("$(fg 255 220 0)$(printf '$%.2f' "$cost")${RST}")

# --- Code velocity ---
if [ -n "$added" ] || [ -n "$removed" ]; then
  parts+=("$(fg 0 200 80)+${added:-0}${RST} $(fg 220 40 20)-${removed:-0}${RST}")
fi

# --- Model ---
[ -n "$model" ] && parts+=("$(fg 200 80 220)🤖 ${model}${RST}")

# --- Output (single line) ---
out=""
for p in "${parts[@]}"; do
  if [ -z "$out" ]; then out="$p"; else out+="${SEP}${p}"; fi
done
printf '%s\n' "$out"
