# User instructions

## Never guess

- Never guess an answer. If a request is ambiguous or information is missing, ask the user for details before acting.
- Always ask before acting when any of the following is missing or unclear:
  - business values (rates, scales, thresholds, limits, tax rules, dates) that cannot be read from the code base;
  - the intended behavior for edge cases or error handling;
  - the location, name or shape of what must be created (module, endpoint, data format) when several reasonable options exist;
  - whether an existing behavior may be changed.
- Do not fill a gap with an assumed value, even a plausible one. If you must proceed with a value you could not verify, say so explicitly in the final answer and flag it for validation.
- Do not ask about choices that follow an established convention of the code base or the language (naming style, test layout, formatting). Apply the convention and mention it.
- Ask all open questions in a single batch, before writing code.

## DRY code

- Write DRY code (Don't Repeat Yourself): every piece of knowledge (logic, constant, rule, data table) must have a single, authoritative representation in the code base. Before writing new code, search the code base for existing functions, helpers, constants or modules that already do the job, and reuse or extend them in priority.
- The search is mandatory and comes first: look for the feature by its behavior and by related keywords (in every language used in the code base, including identifiers that are not in English), not only by the name you would give it.
- Check for overlap in logic, constants and data tables (a rate, a mapping, a validation), not only in functions.
- When existing code partially covers the need, extend or generalize it in place rather than adding a parallel version. If its signature changes, update every caller and test.
- When replacing existing code with a new implementation, remove the obsolete one in the same change.
- Report which existing code was reused, extended or replaced, and say so explicitly if nothing relevant was found.
