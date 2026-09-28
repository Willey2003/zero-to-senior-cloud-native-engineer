#!/usr/bin/env python3
"""Analyse an nginx/apache access log.

Usage:
    python3 log_analyzer.py access.log --top 5
    python3 log_analyzer.py --demo          # generates a sample log first
"""
import argparse
import random
import re
from collections import Counter
from pathlib import Path

LINE_RE = re.compile(
    r'(?P<ip>\S+) \S+ \S+ \[(?P<time>[^\]]+)\] "(?P<method>\S+) (?P<path>\S+) \S+" (?P<status>\d{3}) (?P<size>\S+)'
)


def parse_line(line):
    """Return a dict for one log line, or None if the line does not match."""
    m = LINE_RE.match(line)
    if not m:
        return None
    d = m.groupdict()
    d["status"] = int(d["status"])
    return d


def analyze(lines):
    total, errors = 0, 0
    ips, paths, err_ips = Counter(), Counter(), Counter()
    for line in lines:
        rec = parse_line(line)
        if rec is None:
            continue
        total += 1
        ips[rec["ip"]] += 1
        paths[rec["path"]] += 1
        if rec["status"] >= 500:
            errors += 1
            err_ips[rec["ip"]] += 1
    return {
        "total": total,
        "error_rate": round(errors / total * 100, 2) if total else 0.0,
        "top_ips": ips,
        "top_paths": paths,
        "top_error_ips": err_ips,
    }


def make_demo(path, n=1000):
    ips = [f"10.0.0.{i}" for i in range(1, 20)]
    pages = ["/", "/login", "/api/items", "/api/orders", "/health"]
    with open(path, "w") as f:
        for _ in range(n):
            status = random.choices([200, 301, 404, 500, 503], [80, 5, 8, 5, 2])[0]
            f.write(f'{random.choice(ips)} - - [27/Sep/2026:10:00:00 +0530] '
                    f'"GET {random.choice(pages)} HTTP/1.1" {status} 512\n')


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("logfile", nargs="?", default="demo_access.log")
    p.add_argument("--top", type=int, default=5)
    p.add_argument("--demo", action="store_true")
    args = p.parse_args()
    if args.demo:
        make_demo(args.logfile)
    report = analyze(Path(args.logfile).read_text().splitlines())
    print(f"Requests: {report['total']}   5xx error rate: {report['error_rate']}%")
    for title in ("top_ips", "top_paths", "top_error_ips"):
        print(f"\n{title.replace('_', ' ').title()}:")
        for key, count in report[title].most_common(args.top):
            print(f"  {count:6d}  {key}")


if __name__ == "__main__":
    main()
