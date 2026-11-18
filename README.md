# personal-custom-claude

Journal d'apprentissage de ma formation IA : je personnalise [Claude Code](https://claude.com/claude-code) thème par thème. Chaque section explique **ce que je configure, où, et pourquoi**.

## Sommaire

1. [Règles de comportement : `CLAUDE.md`](#1-règles-de-comportement--claudemd)
2. [Permissions et réglages : `settings.json`](#2-permissions-et-réglages--settingsjson)
3. [Les trois niveaux de configuration](#3-les-trois-niveaux-de-configuration)
4. [Hooks](#4-hooks)
5. [Skills](#5-skills)
6. [Barre de statut : `statusLine`](#6-barre-de-statut--statusline)
7. [MCP : GitHub et Claude Design](#7-mcp--github-et-claude-design)
8. [Ressources](#8-ressources)

---

## 1. Règles de comportement : `CLAUDE.md`

**À quoi ça sert** : `CLAUDE.md` est un fichier de consignes que Claude relit à chaque session. C'est le bon endroit pour décrire *comment* je veux qu'il travaille, pas ce qu'il a le droit de faire (voir section 2).

**Où** : `~/.claude/CLAUDE.md` (global, valable pour tous mes projets). Un `CLAUDE.md` à la racine d'un projet s'applique en plus, uniquement à ce projet.

### Règle « Never guess »

- **Règle** : ne jamais deviner. Si une information manque, Claude me la demande avant d'agir.
- **Quand il doit demander** : valeurs métier introuvables dans le code (taux, seuils, dates…), comportement attendu sur les cas limites ou les erreurs, emplacement/nom/forme de ce qu'il doit créer quand plusieurs options existent, autorisation de modifier un comportement existant.
- **Quand il ne doit pas demander** : si une convention du code ou du langage répond déjà (nommage, organisation des tests, formatage). Il l'applique et le mentionne.
- **Format** : toutes les questions en un seul lot, avant d'écrire du code.
- **Pourquoi** : une valeur inventée mais plausible est pire qu'une question, car l'erreur passe inaperçue. Le lot unique évite les allers-retours.

### Règle « DRY code »

- **Règle** : chaque connaissance (logique, constante, règle, table de données) a une seule représentation dans le code.
- **Méthode** : avant d'écrire, Claude cherche l'existant par comportement et par mots-clés (y compris dans une autre langue que l'anglais), puis réutilise, étend ou remplace. Si une signature change, il met à jour appelants et tests ; si un code est remplacé, l'ancien est supprimé dans le même changement.
- **Compte rendu** : il indique ce qu'il a réutilisé, étendu ou remplacé, ou dit explicitement qu'il n'a rien trouvé.
- **Pourquoi** : éviter les doublons qui divergent avec le temps.

> Bonne pratique retenue : une règle = un titre, des puces vérifiables, et le « pourquoi » à côté. Une consigne vague (« écris du bon code ») ne change rien au comportement.

---

## 2. Permissions et réglages : `settings.json`

**À quoi ça sert** : contrairement à `CLAUDE.md`, ce fichier est appliqué par Claude Code lui-même. Ce n'est pas une demande faite au modèle, c'est une barrière.

**Où** : `~/.claude/settings.json` (scope user).

### Permissions

| Catégorie | Effet | Ce que j'y ai mis |
|---|---|---|
| `allow` | exécuté sans confirmation | `Read`, `Glob`, `Grep`, `git status/diff/log/branch`, `ls`, `pwd` |
| `ask` | confirmation à chaque fois | `git push`, `git commit`, `npm publish` |
| `deny` | interdit | lecture de `.env`, `.env.*`, `secrets/**` ; `rm -rf` ; `curl` |

**Logique** : j'autorise ce qui est en lecture seule, je fais valider ce qui est difficile à annuler ou visible de l'extérieur (publier, committer), j'interdis ce qui est destructeur ou peut exposer des secrets.

### Autres réglages

- `defaultMode: auto` : mode de permission par défaut.
- `model: sonnet`, effort `medium` pour `claude-sonnet-5-5` : compromis vitesse/qualité.
- `theme: dark`, `autoUpdatesChannel: latest` : confort et mises à jour.

---

## 3. Les trois niveaux de configuration

| Niveau | Fichier | Portée | Versionné |
|---|---|---|---|
| User | `~/.claude/settings.json` | tous mes projets | non |
| Projet | `.claude/settings.json` | ce dépôt, partagé avec l'équipe | oui |
| Local | `.claude/settings.local.json` | ce dépôt, juste pour moi | non |

Le plus spécifique complète ou remplace le plus général.

**Règle de choix** : ce qui est mon goût personnel va en user ; ce dont l'équipe a besoin pour travailler pareil va en projet ; ce qui est à moi mais propre à ce dépôt va en local.

**État** : le settings projet n'existe pas encore dans ce dépôt.

- [ ] Créer `.claude/settings.json` et y noter son contenu et sa raison d'être.

---

## 4. Hooks

**Principe** : un hook est une commande exécutée automatiquement par Claude Code à un moment précis (avant/après un outil, à la fin d'une réponse…). Contrairement à `CLAUDE.md`, il ne dépend pas de la bonne volonté du modèle.

**Où** : dans la clé `hooks` d'un `settings.json`.

### Exemple : le hook de synchronisation `SessionStart`

**Objectif** : garder dans ce dépôt une copie à jour de ma configuration user (`~/.claude`), pour la versionner et la retrouver sur une autre machine. Le dépôt n'est pas dans `~/.claude` : il faut donc une copie, faite automatiquement à chaque démarrage de session.

**Événement** : `SessionStart`, déclenché quand une session démarre ou reprend.

**Déclaration** (clé `hooks` de `~/.claude/settings.json`) :

```json
"hooks": {
  "SessionStart": [
    {
      "hooks": [
        {
          "type": "command",
          "command": "bash C:/Users/Maki/.claude/hooks/sync-user-config.sh"
        }
      ]
    }
  ]
}
```

**Le script** (`~/.claude/hooks/sync-user-config.sh`) :

| Source (`~/.claude/`) | Copie (`user-config/`) | Mode |
|---|---|---|
| `CLAUDE.md`, `settings.json`, `statusline-command.sh` | mêmes noms | fichier écrasé |
| `skills/`, `commands/`, `agents/`, `hooks/` | mêmes noms | miroir : dossier vidé puis recopié |

1. **Copie à sens unique** : `~/.claude` → dépôt, jamais l'inverse.
2. **Miroir** : un skill supprimé côté user disparaît aussi de la copie. Un dossier absent côté user (`commands/`, `agents/` n'existent pas encore) est ignoré.
3. **Exclusion de `skills/synced/`** : skills Anthropic gérés automatiquement, volumineux et qui ne sont pas les miens.
4. **Commit et push** : seul `user-config/` est ajouté (`git add -A -- user-config`). S'il n'y a aucun changement, rien n'est commité. Le message est « Synchronise la configuration user de Claude Code ». Un échec du push ne bloque pas le démarrage de la session (le script termine toujours en `exit 0`).

**Le `.gitignore` en liste blanche** : tout est ignoré (`*`) sauf ce qui est listé. Pour chaque dossier (`skills/`, `commands/`, `agents/`, `hooks/`), il faut **deux lignes** : `!/user-config/<dossier>/` pour ré-inclure le dossier, puis `!/user-config/<dossier>/**` pour son contenu. Avec une seule des deux, git ignore les fichiers sans le dire.

**Pièges rencontrés**

- Le `.gitignore` ignorait le contenu de `skills/` et `hooks/` : `git status` ne montrait rien. Voir la règle des deux lignes ci-dessus.
- Les règles `ask` de `git commit` et `git push` (section 2) ne concernent que les appels faits par Claude. Un hook s'exécute sans confirmation : il commit et pousse tout seul, à chaque session.
- Le chemin du dépôt est écrit en dur dans le script : à adapter sur une autre machine.
- `settings.json` est copié tel quel et poussé : y mettre un secret (token, clé) le publierait. Les secrets vont dans une variable d'environnement, jamais dans ce fichier.

**Vérifier** : lancer le script à la main (`bash ~/.claude/hooks/sync-user-config.sh`), puis `git log -1 --stat`. Pour tester le déclenchement, relancer Claude Code.

---

## 5. Skills

**Principe** : un skill est un jeu d'instructions réutilisable, chargé à la demande (par `/nom` ou quand sa description correspond à la tâche).

**Où** : `~/.claude/skills/<nom>/SKILL.md` (global) ou `.claude/skills/<nom>/SKILL.md` (projet).

### Exemple : le skill `init-gitignore`

**Objectif** : générer un `.gitignore` adapté au projet, en demandant à l'utilisateur son langage, son framework et son éditeur au lieu de les deviner (ce qui applique la règle « Never guess » de la section 1).

**Structure** (dossier `~/.claude/skills/init-gitignore/`) :

```
init-gitignore/
├── SKILL.md       # le déroulé : quoi demander, quoi lire, quoi écrire
└── templates.md   # les patterns, une section par valeur
```

**Le `SKILL.md`**

- En-tête (frontmatter) : `name` et `description`. La description sert à Claude pour décider de charger le skill : elle dit *ce qu'il fait* et *quand l'utiliser* (« initialiser, générer, créer un `.gitignore` »).
- Corps : les étapes ci-dessous.

**Le déroulé**

1. **Questions en un seul appel** (`AskUserQuestion`, choix multiples, « Autre » toujours possible) :

   | Question | Choix proposés |
   |---|---|
   | Langage | Python, JavaScript/TypeScript, Java, Go, C# |
   | Framework | dépend du langage (Python : Flask, Django ; JS/TS : Node, React, Next.js ; Java : Maven, Gradle ; Go/C# : aucun), plus « Aucun » |
   | Éditeur | VS Code, JetBrains, Vim, Visual Studio |

   Limite de 4 options par question : les plus courantes en premier.
2. **Lecture de `templates.md`** : chaque section `## Catégorie: Nom` est la source unique des patterns. Le skill prend les sections qui correspondent aux réponses, plus `Common: OS` (toujours incluse).
3. **Valeur non gérée** : pas de patterns inventés. Le skill le signale et demande s'il faut l'ignorer ou s'arrêter.
4. **`.gitignore` déjà présent** : choix entre écraser, fusionner (ajouter seulement les patterns manquants) ou annuler. Rien n'est modifié avant la réponse.
5. **Écriture** : un bloc par section, précédé d'un commentaire `# Nom`, sans doublon.
6. **Compte rendu** : chemin du fichier et sections incluses.

**Ce que ça illustre**

- **Poser des questions plutôt que deviner** : le choix langage / framework / éditeur est demandé, et le skill s'arrête si la réponse n'est pas couverte.
- **DRY** : les patterns vivent uniquement dans `templates.md`. Pour gérer un nouveau langage, on ajoute une section dans ce fichier et on l'ajoute à la liste de l'étape 1, sans copier de patterns dans `SKILL.md`.
- **Sécurité** : jamais d'écrasement d'un fichier existant sans accord explicite.

**Installation** : le skill a été ajouté dans un autre projet puis se retrouve dans `~/.claude/skills/`, donc disponible partout. Pour le limiter à un dépôt, le placer dans `.claude/skills/init-gitignore/`.

**Utilisation** : `/init-gitignore`, ou une phrase du type « crée un `.gitignore` ».


---

## 6. Barre de statut : `statusLine`

**À quoi ça sert** : afficher en permanence, sous le champ de saisie, l'état de la session (dépôt, branche, consommation, modèle…). Claude Code exécute une commande à chaque mise à jour et affiche sa sortie.

**Où** : clé `statusLine` de `~/.claude/settings.json`, qui pointe vers un script :

```json
"statusLine": {
  "type": "command",
  "command": "bash C:/Users/Maki/.claude/statusline-command.sh"
}
```

**Le script** (`~/.claude/statusline-command.sh`) lit sur l'entrée standard un JSON fourni par Claude Code (modèle, répertoire, coût, lignes ajoutées/supprimées, limites d'usage) et imprime une seule ligne en couleurs truecolor (RGB 24 bits). Il utilise `jq` s'il est installé, sinon un repli en `sed`.

**Ce qu'il affiche** : nom du dépôt, 🌿 branche git, emoji + barre de 20 blocs en dégradé vert → jaune → rouge pour la limite des 5 h, coût de la session, lignes ajoutées/supprimées, 🤖 modèle. Un élément dont la donnée manque est simplement omis.

**Source d'inspiration** : le gist d'AKCodez, https://gist.github.com/AKCodez/ffb420ba6a7662b5c3dda2edce7783de

**À savoir**

- La limite des 5 h est une fenêtre glissante, pas une consommation par jour calendaire.
- Le champ `rate_limits` n'est pas toujours fourni par Claude Code : sans lui, la barre n'apparaît pas.
- Le script se teste hors de Claude Code en lui envoyant un JSON d'exemple : `echo '{"model":{"display_name":"Sonnet"}}' | bash ~/.claude/statusline-command.sh`.

---

## 7. MCP : GitHub et Claude Design

**Principe** : un serveur MCP (Model Context Protocol) donne à Claude des outils supplémentaires pour parler à un service externe. J'en ai ajouté deux :

| Serveur | Ce qu'il apporte |
|---|---|
| GitHub | agir sur GitHub (dépôts, issues, pull requests) sans passer par la ligne de commande |
| Claude Design | travailler sur des designs depuis Claude |

Voir les serveurs actifs et leurs outils : commande `/mcp` dans Claude Code.

### Warnings

- **Un MCP agit vraiment** : ce n'est pas une simple lecture. Un outil MCP peut créer, modifier ou supprimer des choses chez le service externe, parfois de façon difficile à annuler.
- **Les droits de Claude = les droits de mon compte** : si l'autorisation donnée à GitHub est large, tout ce que Claude peut faire l'est aussi.
- **Du contenu externe n'est pas fiable** : une issue, une pull request ou un fichier lu via MCP peut contenir des instructions cachées (*prompt injection*). Claude doit les traiter comme des données, jamais comme des ordres.
- **Chaque outil coûte du contexte** : leurs descriptions sont chargées dans la conversation, ce qui la remplit plus vite et peut brouiller le choix des outils.

### Utiliser les MCP avec parcimonie

- N'activer que les serveurs utiles à la tâche en cours, et désactiver le reste (`/mcp`).
- Ne pas ajouter un serveur « au cas où » : chaque ajout agrandit la surface d'attaque et le contexte consommé.
- Préférer un serveur dont je connais la source (éditeur officiel) à un serveur trouvé au hasard : il s'exécute avec mes droits.

### Sécurité

- **Moindre privilège** : donner à GitHub l'accès minimal nécessaire (dépôts concernés, lecture seule si l'écriture n'est pas utile), et jamais plus.
- **Secrets** : un token ne va ni dans le README, ni dans un fichier versionné. Le `.env` reste couvert par la règle `deny` de la section 2.
- **Permissions** : traiter les outils MCP comme le reste (section 2) : lecture autorisée, écriture (créer, fusionner, supprimer) en `ask`, actions destructrices en `deny`.
- **Relire avant de valider** : toute action d'écriture visible de l'extérieur (publier, fusionner, commenter) est relue avant d'être acceptée.

### Ne pas utiliser un MCP quand un autre outil existe

- **Règle** : si un outil intégré ou une commande locale fait le même travail, je l'utilise à la place du MCP.
- **Exemples** : pour l'état d'un dépôt local, `git status`, `git diff` et `git log` (déjà en `allow`) ; pour pousser, `git push` ou la CLI `gh`. Le MCP GitHub est réservé à ce qu'ils ne font pas bien.
- **Pourquoi** : un outil local est plus rapide, ne consomme pas de contexte en plus, passe par des permissions déjà définies et n'ouvre aucun accès externe supplémentaire.

**État** : à compléter une fois vérifiés : la commande exacte d'ajout de chaque serveur, son scope (user, projet, local) et les droits accordés à GitHub.

- [ ] Documenter l'installation de chaque serveur (commande, scope).
- [ ] Noter les permissions `ask`/`deny` posées sur les outils MCP.

---

## 8. Ressources

- Documentation Claude Code : https://docs.claude.com/en/docs/claude-code
- Gist de status line d'AKCodez : https://gist.github.com/AKCodez/ffb420ba6a7662b5c3dda2edce7783de