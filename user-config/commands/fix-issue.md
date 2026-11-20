---
description: Équipe de sous-agents issue → diagnostic → correctif → PR locale (texte de l'issue en argument)
argument-hint: <numéro et texte de l'issue>
---

Orchestre l'équipe de sous-agents du projet sur cette issue :

$ARGUMENTS

Si l'argument est vide ou ne contient pas le texte de l'issue, demande à l'utilisateur de le coller et arrête-toi.

Séquence (chaque étape reçoit la sortie de la précédente) :
1. Agent `issue-reader` : résumé structuré de l'issue.
2. Agent `bug-locator` : cause racine et test de reproduction proposé.
3. **PAUSE** : présente le diagnostic à l'utilisateur (cause racine, correctif envisagé, incertitudes) et attends son accord explicite. Pose en une seule fois les questions ouvertes remontées par les agents.
4. Agent `bug-fixer` : test qui échoue, puis correctif minimal.
5. Agent `fix-reviewer` : verdict. Si `À CORRIGER`, renvoie à `bug-fixer` (2 boucles maximum, puis remonte le blocage à l'utilisateur).
6. Agent `pr-writer` : `CHANGES.rst`, branche locale, commit, `PR.md`.

Rappels : pas de lecture des branches `after-*`/`main`/`origin/`, pas de `gh`, pas de push, pas de réseau. Conclus par un récapitulatif : branche, commit, chemin de `PR.md`, tests, et tout point non vérifié à valider.
