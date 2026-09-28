# Lab 17: AI, LLM Apps and MLOps on Kubernetes

## Concepts in plain words
- **Model**: a program learned from data instead of written by hand. **Training** = learning. **Inference** = using it.
- **LLM** (large language model): predicts text; used via a hosted API or self-hosted open models.
- **Embedding**: a list of numbers that represents meaning; similar meaning = close numbers.
- **RAG** (retrieval augmented generation): find relevant documents with embeddings, give them to the LLM to answer from.
- **Agent**: an LLM that can call tools (APIs, shell) in a loop.
- **MLOps**: CI/CD + monitoring for models: data/versioning, training pipelines, model registry, serving, drift monitoring.

## Part A: Python + LLM APIs
Start with `rag/simple_rag.py`: it builds a tiny RAG over the Markdown files in this repo using TF-IDF retrieval
(no GPU, no paid API needed). Then swap retrieval for real embeddings and a vector DB (Qdrant/pgvector), and
the answer step for an LLM API call. Always read keys from environment variables, never from code.

## Part B: Serving on Kubernetes
- Containerise the RAG service, deploy it like the lab API, expose via Gateway, add HPA.
- Model serving: **KServe** `InferenceService` (`manifests/kserve-sklearn.yaml`), vLLM for open LLMs, GPU nodes with
  the NVIDIA GPU Operator, node selectors/taints for GPU pools, Kueue for batch jobs.
- Pipelines: Kubeflow Pipelines or Argo Workflows (Lab 12) for train → evaluate → register → deploy.
- Observability for AI: latency, tokens/sec, cost per request, quality evals.

## Real-world scenarios
1. "The chatbot answers from outdated docs." Add re-indexing on Git push (Argo Events → Workflow).
2. "GPU nodes cost too much and sit idle." Scale-to-zero with KServe/Knative, Kueue queues, spot GPU pools.
3. "Model latency p99 is 8 s." Batch size, model size, caching, streaming responses.
