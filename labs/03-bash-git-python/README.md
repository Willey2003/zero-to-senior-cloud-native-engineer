# Lab 03: Bash, Git and Python

## Why this matters
Automation is what separates a DevOps engineer from a manual admin. Bash glues Linux commands together;
Python builds real tools and talks to cloud and Kubernetes APIs; Git stores and shares all your work.

## Part A: Bash (2 weeks)
Read and run the scripts in `bash/` in order. Each one teaches one idea and is heavily commented.
- `01-basics.sh`: variables, quotes, arguments, exit codes, `if`, loops, functions.
- `02-health-check.sh`: a real script that checks disk, memory, and services and returns an alert.
Always start scripts with `set -euo pipefail` and check them with `shellcheck`.

## Part B: Git (1 week)
```bash
git switch -c feature/health-check     # new branch
# edit files...
git add -p                             # review each change before staging
git commit -m "feat: add disk check"
git push -u origin feature/health-check
# open a Pull Request on GitHub, review it, merge it
git switch main && git pull
git log --oneline --graph --all
```
Practise conflicts: two branches edit the same line, merge, fix the `<<<<<<<` markers, commit.
Learn: `git stash`, `git revert` (safe undo of a pushed commit), `git reset` (only for unpushed work), `.gitignore`.

## Part C: Python (3 weeks)
1. Setup: `python3 -m venv .venv && source .venv/bin/activate && pip install -r python/requirements.txt`
2. Basics: do the Python official tutorial chapters 3-9. Type every example.
3. Real tools in `python/`:
   - `log_analyzer.py`: reads a web access log, reports top IPs, error rates. (files, dicts, regex, argparse)
   - `health_checker.py`: checks a list of URLs concurrently and prints a table. (HTTP, error handling, threads)
   - `app.py`: a small REST API (FastAPI) with `/health` and `/items`. You will containerise it in Lab 04
     and deploy it to Kubernetes in Lab 07.
4. Tests: `pytest -q python/tests`. Every tool you write from now on has at least one test.

## Real-world scenarios
1. Your manager asks: "Which IPs caused the most 5xx errors yesterday?" Answer with `log_analyzer.py`.
2. A cron job silently fails. Add logging, exit codes and an alert to `02-health-check.sh`.
3. Extend `health_checker.py` to post failures to a Slack/Teams webhook.

## Check yourself
- [ ] Write a Bash script that takes a directory and deletes files older than N days, with a `--dry-run` flag.
- [ ] Explain `git merge` vs `git rebase`.
- [ ] Write a Python function with a test, and run it in CI (you will do CI in Lab 06).
