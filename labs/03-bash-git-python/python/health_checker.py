#!/usr/bin/env python3
"""Check many URLs at once and print a status table.

Usage: python3 health_checker.py https://example.com https://httpbin.org/status/503
Exit code is 1 if any URL is unhealthy (so CI or cron can alert).
"""
import sys
import time
from concurrent.futures import ThreadPoolExecutor

import requests


def check(url, timeout=5):
    start = time.monotonic()
    try:
        r = requests.get(url, timeout=timeout)
        ok = r.status_code < 400
        detail = str(r.status_code)
    except requests.RequestException as exc:
        ok, detail = False, type(exc).__name__
    return url, ok, detail, round((time.monotonic() - start) * 1000)


def main(urls):
    if not urls:
        print(__doc__)
        return 2
    with ThreadPoolExecutor(max_workers=10) as pool:
        results = list(pool.map(check, urls))
    print(f"{'STATUS':8} {'CODE':22} {'MS':>6}  URL")
    for url, ok, detail, ms in results:
        print(f"{'UP' if ok else 'DOWN':8} {detail:22} {ms:6d}  {url}")
    return 0 if all(r[1] for r in results) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
