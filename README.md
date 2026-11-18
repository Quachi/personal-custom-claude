# personal-custom-claude

Journal d'apprentissage de ma formation IA : je personnalise [Claude Code](https://claude.com/claude-code) pas à pas et je garde ici une trace de ce que je fais et de ce que j'apprends.

## Parcours

| Étape | Sujet | Statut |
|---|---|---|
| 1 | Instructions globales (`CLAUDE.md`) | Fait |
| 2 | Settings scope user | Fait |
| 3 | Settings scope projet | Fait |
| 4 | Hook | Fait (à documenter) |
| 5 | Skills personnalisés | À venir |

## Journal

### 2026-11-18 : premières bases

**Ce que j'ai mis en place**

- `~/.claude/CLAUDE.md` : deux règles de comportement pour Claude.
  - *Never guess* : il pose ses questions en un seul lot avant d'agir au lieu de deviner.
  - *DRY code* : il cherche le code existant avant d'en écrire du nouveau, puis réutilise, étend ou remplace.
- `~/.claude/settings.json` (scope user) :
  - permissions **allow** : `Read`, `Glob`, `Grep`, `git status/diff/log/branch`, `ls`, `pwd` ;
  - permissions **ask** : `git push`, `git commit`, `npm publish` ;
  - permissions **deny** : lecture de `.env`, `.env.*`, `secrets/**` ; `rm -rf` ; `curl` ;
  - modèle `sonnet`, effort `medium`, thème `dark`, mises à jour `latest`.
- Un settings scope projet (`.claude/settings.json`).
- Un hook.

**Ce que j'ai appris**

- Les settings existent à trois niveaux : *user* (`~/.claude/settings.json`, tous les projets), *projet* (`.claude/settings.json`, partagé via git) et *local* (`.claude/settings.local.json`, personnel, non versionné). Le plus spécifique complète ou remplace le plus général.
- Les permissions se rangent en trois catégories : `allow` (sans confirmation), `ask` (confirmation) et `deny` (interdit).
- `CLAUDE.md` sert à donner des consignes durables de comportement, alors que `settings.json` règle les permissions et la configuration.
- Un hook est une automatisation exécutée par Claude Code lui-même à un moment précis (avant ou après un outil, à la fin d'une réponse…), et non une simple consigne donnée à Claude.

**À compléter**

- [ ] Hook : événement déclencheur, rôle, script, emplacement. Aucun hook n'est visible dans `~/.claude/settings.json` ni dans ce dépôt, à retrouver ou à décrire.
- [ ] Settings projet : y noter ce qu'ils contiennent et pourquoi.

## Prochaines étapes : skills personnalisés

Un skill est un ensemble d'instructions réutilisable, dans `.claude/skills/<nom>/SKILL.md` (projet) ou `~/.claude/skills/` (global).

- [ ] Skill 1 : à définir
- [ ] Skill 2 : à définir

## Ressources

- Documentation Claude Code : https://docs.claude.com/en/docs/claude-code
