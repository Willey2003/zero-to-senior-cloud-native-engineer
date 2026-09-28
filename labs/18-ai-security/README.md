# Lab 18: AI Security

## Why this matters
Every company is shipping LLM features, and few engineers know how to secure them. Combining Kubernetes security
+ cloud security + AI security is one of the highest-paid niches right now.

## Threats (OWASP Top 10 for LLM Applications, MITRE ATLAS)
| Threat | Plain meaning | Defence |
|---|---|---|
| Prompt injection (direct/indirect) | Text in the input or a retrieved document tells the model to ignore its rules | Treat model output as untrusted, separate instructions from data, least-privilege tools, human approval for risky actions |
| Sensitive information disclosure | Model leaks secrets/PII from context or training | Don't put secrets in prompts, output filtering, access control on RAG documents per user |
| Supply chain | Poisoned models/datasets, malicious pickle files | Use safetensors, verify hashes/signatures, scan models, private registry |
| Data and model poisoning | Attacker plants bad data in training/RAG sources | Source allow-lists, review, provenance |
| Improper output handling | Model output executed as code/SQL/HTML | Validate, escape, sandbox |
| Excessive agency | Agent has too many tools/permissions | Scoped tokens, allow-lists, rate limits, audit logs |
| System prompt leakage | Hidden instructions revealed | Assume system prompts are public; no secrets in them |
| Vector/embedding weaknesses | Cross-tenant data leaks in vector DB | Per-tenant namespaces and filters |
| Misinformation | Confident wrong answers | Grounding, citations, evals |
| Unbounded consumption | Cost/DoS via huge prompts | Quotas, max tokens, rate limiting at the AI gateway |

## Hands-on
1. Run `prompt_injection_lab.py`: a toy "support bot" with a naive filter. Try the attack prompts, see which bypass it,
   then implement the defences listed in the file and re-run the test suite.
2. Secure the Lab 17 RAG service on Kubernetes: NetworkPolicy egress allow-list (only the LLM API and vector DB),
   Secrets from External Secrets, non-root, Kyverno image verification, Falco rule for unexpected shells, audit logging
   of prompts (with PII redaction).
3. Add an AI gateway (e.g. Envoy AI Gateway or LiteLLM) for auth, rate limits and token quotas per team.
4. Red-team your own app with an open-source tool (garak or promptfoo) and track findings like CVEs.

## Real-world scenario
"Our RAG bot leaked another customer's invoice." Root cause: vector search without tenant filter. Fix: tenant ID in
metadata + mandatory filter + tests; post-mortem.
