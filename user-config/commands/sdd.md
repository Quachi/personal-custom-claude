---
description: Spec-Driven Development — enchaîne spec → plan → tâches → implémentation → validation avec pause de validation entre chaque étape (besoin en argument)
argument-hint: <besoin ou feature à développer>
---

Orchestre l'équipe de sous-agents SDD sur ce besoin :

$ARGUMENTS

Si l'argument est vide, demande à l'utilisateur de décrire le besoin et arrête-toi.

Dossier de travail : `docs/specs/<feature>/`, où `<feature>` est un nom court en kebab-case déduit du besoin. Annonce-le à l'utilisateur ; s'il est ambigu, demande-le. Si le dossier existe déjà, demande s'il faut reprendre à une étape donnée ou écraser.

Séquence (chaque agent reçoit le besoin, le nom `<feature>` et les fichiers produits par les étapes précédentes) :
1. Agent `sdd-spec` → `spec.md`.
   **PAUSE** : présente la spec et ses questions ouvertes, pose-les en un seul lot, fais compléter `spec.md` avec les réponses (relance `sdd-spec`), puis attends l'accord explicite de l'utilisateur et passe le statut à `approved`.
2. Agent `sdd-plan` → `plan.md`.
   **PAUSE** : présente architecture, stack, contrats et questions ouvertes ; attends l'accord explicite.
3. Agent `sdd-tasks` → `task.md`.
   **PAUSE** : présente les tâches et la matrice de traçabilité ; attends l'accord explicite.
4. Agent `sdd-impl` → code, tests, documentation et `impl.md`.
5. Agent `sdd-validate` → `validation.md`. Si le verdict est `À CORRIGER`, renvoie les points à `sdd-impl` puis relance `sdd-validate` (2 boucles maximum, puis remonte le blocage à l'utilisateur).

Rappels : ne devine jamais, ne comble aucune question ouverte toi-même, remonte-les à l'utilisateur. Pas de lecture des branches `after-*`/`main`/`origin/`, pas de `gh`, pas de commit ni de push, pas de réseau. Conclus par un récapitulatif : fichiers produits dans `docs/specs/<feature>/`, résultat des tests, verdict de validation et tout point non vérifié à valider.
