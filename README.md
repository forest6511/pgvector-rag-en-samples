# pgvector-rag-en-samples

Runnable sample code for the book **pgvector at Scale for PostgreSQL** (*Production Vector Search
and RAG*) by Yosuke Morikawa.

Every SQL and Python sample in the book is run for real against a Docker PostgreSQL + pgvector
instance, and the verified output is what you see in the book. This repo is that code, ready to
run yourself.

## Contents

The book is mostly concept and decision frameworks; only the chapters with runnable code have a
directory here.

- Ch00–Ch02 — introduction, RAG anatomy, and the stay-or-leave decision. Concept/decision
  chapters, no runnable code.
- [ch03-internals](ch03-internals/README.md) — how pgvector stores and searches vectors:
  vector types, distance operators, HNSW vs IVFFlat.
- [ch04-setup](ch04-setup/README.md) — installing pgvector locally and across the managed
  ecosystem (RDS / Supabase vecs / Neon / AlloyDB).
- [ch05-design](ch05-design/README.md) — table & vector type design: `vector` / `halfvec` /
  `sparsevec` / `bit`, storage sizes, the production `chunks` schema.
- Ch06 — embedding models. Syntax only (embedding APIs are billed and volatile), no captured
  output, so no directory here.
- [ch07-chunking](ch07-chunking/README.md) — chunking for English & multilingual corpora.
  **Python** samples (tiktoken / spaCy / NLTK / langchain-text-splitters), not SQL.
- [ch08-tuning](ch08-tuning/README.md) — HNSW & IVFFlat tuning, the post-filter underfill bug,
  and pgvector 0.8.0 iterative scans.
- [ch09-hybrid](ch09-hybrid/README.md) — hybrid search: tsvector vs ParadeDB pg_search (real
  BM25) + RRF fusion. Uses **two** Postgres images.
- [ch10-cost](ch10-cost/README.md) — cost engineering: `halfvec`, binary quantization, the RAM
  wall, two-stage rerank.
- [ch11-ops](ch11-ops/README.md) — observability & production pitfalls: index size, recall@k,
  `CREATE INDEX CONCURRENTLY`.
- [ch12-beyond](ch12-beyond/README.md) — when Postgres isn't enough: pgvectorscale
  (StreamingDiskANN + SBQ). Uses a **Timescale** image.

## What's in each chapter directory

- `compose.yaml` — starts PostgreSQL + pgvector for that chapter (SQL chapters only).
- `init.sql` — creates the extension, schema, and seed data.
- `examples/*.sql` or `examples/*.py` — the code shown in the chapter.
- `README.md` — how to run it.

Most chapters are SQL against Docker Postgres. Two exceptions: **ch07-chunking** is pure Python
(run it in a venv — see its README), and **ch09-hybrid** / **ch12-beyond** use a non-default
Postgres image (ParadeDB and Timescale respectively).

## Getting started

```bash
git clone https://github.com/forest6511/pgvector-rag-en-samples.git
cd pgvector-rag-en-samples/ch03-internals
docker compose up -d
docker compose exec -T db psql -U postgres -d ragdb < init.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/01_types.sql
docker compose down -v
```

## Environment

- Docker / Docker Compose
- PostgreSQL 18 + pgvector 0.8.2 (image `pgvector/pgvector:pg18`)

## License

MIT — see [LICENSE](LICENSE).
