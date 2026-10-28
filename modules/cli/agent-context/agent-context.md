# Git workflow

- Do not use git worktrees by default. Only create or use a worktree when I explicitly ask for one.
- Make changes directly in the current branch.
- Leave changes uncommitted. Do not commit, unless I explicitly ask you to.

# Making changes

- Only make changes to code when I explicitly ask for them with words like "change", "modify" or "create".
- When I ask how something should be done or fixed, answer the question. DO NOT make any changes to the code.

# Comments

- Do not write comments for readable or obvious code. I will ask for comments if I need them.
- If code seems to need a comment to be understood, make the code clearer instead:
  - Replace magic values with named constants.
  - Name parts of complex expressions with well-named variables, or extract the condition into a well-named function.
  - Use types to express intent (e.g. optional/nullable types instead of sentinel values like `-1`, ownership-expressing types instead of comments about ownership).
- Never write comments that describe *what* the code does; they rot and go out of sync with the code.
- Only write comments explaining *why*, and only when the code is a hack or otherwise non-standard, e.g.:
  - Code that looks odd because of a workaround, upstream bug, or performance reason.
  - Code that implements a specific algorithm or mathematical principle: link to the source.
- Documentation of public APIs (docstrings, doc comments) is not a comment in this sense; keep it concise and focused on how to use the API (contract, error conditions, thread safety), not how it works internally.
