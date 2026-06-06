Thank you for contributing to Openvario!

We truly appreciate your time and effort in making Openvario better. We know
that contributing to an open-source project can be challenging, and we're
grateful that you've chosen to help.

This checklist is here to help guide you through the submission process.
Don't worry if you're not sure about something—feel free to ask questions
or submit your PR, and we'll work together to get it ready.

## Pre-Submission Checklist

Please verify the following before submitting your PR:

### Git & Commit History

#### Branch & Rebase
- [ ] PR is rebased on current branch you wanna commit to 
- [ ] Use `git rebase -i` to clean up commit history before PR
  submission

#### Commit Format & Messages
- [ ] All commits follow the format: `<Component>: <Summary>` (no
  `src/` prefix)
- [ ] Use present tense in commit messages ("Fix" not "Fixed", "Add"
  not "Added")
- [ ] Commit messages explain *why* the change was made, not just
  *what* changed
- [ ] Commit message body (if needed) provides detailed reasoning and
  context

#### Commit Structure
- [ ] Each commit is atomic and builds successfully (every commit
  must compile)
- [ ] One commit per logical change (don't mix refactoring with
  feature changes)
- [ ] Self-contained commits (each commit changes one thing)
- [ ] No fixup commits (squashed into parent commits using
  `git rebase -i`)
- [ ] No duplicate commits (check with `git log --oneline`)
- [ ] No "WIP" or "testing" commits (clean up before PR)

---

- [ ] I'm ready to merge