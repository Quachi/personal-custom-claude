---
description: Équipe de sous-agents issue → plan → implémentation + tests → revue → PR locale (texte de l'issue de feature en argument)
argument-hint: <numéro et texte de l'issue>
---

Orchestre l'équipe de sous-agents du projet sur cette issue de feature :

$ARGUMENTS

Si l'argument est vide ou ne contient pas le texte de l'issue, demande à l'utilisateur de le coller et arrête-toi.

Séquence (chaque étape reçoit la sortie de la précédente) :
1. Agent `issue-reader` : résumé structuré de l'issue (pour une feature, lis « symptôme/attendu » comme « besoin/attendu »).
2. Agent `feature-planner` : conception, code à réutiliser, plan de tests, questions ouvertes.
3. **PAUSE** : présente le plan à l'utilisateur (comportement, fichiers, tests, incertitudes) et attends son accord explicite. Pose en une seule fois les questions ouvertes remontées par les agents.
4. Agent `feature-implementer` : tests d'abord, puis implémentation minimale et documentation.
5. Agent `feature-reviewer` : verdict. Si `À CORRIGER`, renvoie à `feature-implementer` avec les points demandés (2 boucles maximum, puis remonte le blocage à l'utilisateur).
6. Agent `pr-writer` avec le type `feature` : `CHANGES.rst`, branche locale `feat/issue-<N>-<slug>`, commit, `PR.md`.

Rappels : pas de lecture des branches `after-*`/`main`/`origin/`, pas de `gh`, pas de push, pas de réseau. Conclus par un récapitulatif : branche, commit, chemin de `PR.md`, tests, et tout point non vérifié à valider.
