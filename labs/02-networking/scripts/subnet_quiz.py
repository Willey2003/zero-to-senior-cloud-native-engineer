#!/usr/bin/env python3
"""Subnetting practice: random questions, instant feedback. Run: python3 subnet_quiz.py"""
import ipaddress
import random

def question():
    prefix = random.randint(16, 30)
    ip = ipaddress.IPv4Address(random.randint(0x0A000000, 0x0AFFFFFF))  # 10.x.x.x
    net = ipaddress.IPv4Network(f"{ip}/{prefix}", strict=False)
    return ip, prefix, net

def main():
    score = 0
    for i in range(1, 11):
        ip, prefix, net = question()
        print(f"\nQ{i}: {ip}/{prefix}")
        answers = {
            "network address": str(net.network_address),
            "broadcast address": str(net.broadcast_address),
            "usable hosts": str(max(net.num_addresses - 2, 0)),
        }
        for label, correct in answers.items():
            given = input(f"  {label}? ").strip()
            if given == correct:
                score += 1
                print("   correct")
            else:
                print(f"   wrong, it is {correct}")
    print(f"\nScore: {score}/30")

if __name__ == "__main__":
    main()
