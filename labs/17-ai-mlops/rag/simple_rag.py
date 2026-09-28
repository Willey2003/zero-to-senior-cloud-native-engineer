#!/usr/bin/env python3
"""A tiny, dependency-light RAG demo over this repo's Markdown files.

Step 1 (retrieve): split docs into chunks and rank them against the question with TF-IDF.
Step 2 (generate): print the best chunks as the "context". Replace `answer()` with an LLM API
call later (read the API key from an environment variable, never hard-code it).

Usage:  python3 simple_rag.py "how do I back up etcd?"
"""
import math
import re
import sys
from collections import Counter
from pathlib import Path

REPO = Path(__file__).resolve().parents[3]
TOKEN = re.compile(r"[a-z0-9]+")


def tokenize(text):
    return TOKEN.findall(text.lower())


def load_chunks(root=REPO, size=60):
    chunks = []
    for md in root.rglob("*.md"):
        words = md.read_text(errors="ignore").split()
        for i in range(0, len(words), size):
            chunks.append((str(md.relative_to(root)), " ".join(words[i:i + size])))
    return chunks


def rank(question, chunks, k=3):
    docs = [Counter(tokenize(text)) for _, text in chunks]
    df = Counter(term for d in docs for term in d)
    n = len(docs)
    q = tokenize(question)

    def score(doc):
        return sum(doc[t] * math.log((n + 1) / (df[t] + 1)) for t in q if t in doc)

    scored = sorted(((score(d), i) for i, d in enumerate(docs)), reverse=True)[:k]
    return [(s, chunks[i]) for s, i in scored if s > 0]


def answer(question, hits):
    if not hits:
        return "I could not find anything relevant in the labs."
    lines = [f"Question: {question}", "Most relevant lab notes:"]
    for s, (path, text) in hits:
        lines.append(f"\n[{path}] (score {s:.1f})\n{text[:400]}...")
    return "\n".join(lines)


if __name__ == "__main__":
    q = " ".join(sys.argv[1:]) or "how do I back up etcd?"
    print(answer(q, rank(q, load_chunks())))
