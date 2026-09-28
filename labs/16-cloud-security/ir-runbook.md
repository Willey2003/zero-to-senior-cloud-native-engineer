# Runbook: AWS access key leaked publicly

1. **Contain (minutes):** `aws iam update-access-key --user-name X --access-key-id AKIA... --status Inactive`.
   Attach a deny-all inline policy to the user. Do not delete yet (you need evidence).
2. **Scope:** CloudTrail Lake / Athena: all events by that key ID in the last 90 days. Look for `CreateUser`,
   `CreateAccessKey`, `RunInstances`, `PutBucketPolicy`, activity in unusual regions.
3. **Eradicate:** delete any backdoor users/keys/roles the attacker created, terminate rogue instances, revert policies.
4. **Recover:** issue new credentials (prefer roles/SSO), rotate any secrets the key could read.
5. **Lessons learned:** enable GitHub secret scanning + push protection, pre-commit `gitleaks`, remove long-lived keys, SCPs.
6. Write a blameless post-mortem (timeline, impact, root cause, actions with owners).
