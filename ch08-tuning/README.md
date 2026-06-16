# Chapter 8 — HNSW & IVFFlat tuning, iterative scans

Companion code for the chapter. PostgreSQL 18 + pgvector 0.8.2 via Docker.

## Run

```bash
docker compose up -d
docker compose exec -T db psql -U postgres -d ragdb < init.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/hnsw_explain.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/post_filter.sql
docker compose down -v
```

## What the dataset does

`init.sql` loads 10,000 deterministic rows (no randomness — identical on every run). Each
`embedding` points in a direction set by an angle that grows with `id`, so cosine distance to the
query `[1,0,0,...]` grows with `id`: small id = near, large id = far. `status` is `'active'` for a
sparse ~1% of rows, concentrated away from the query, so the rows nearest the query are almost all
`'archived'`. That anti-correlation is what reproduces the post-filter underfill in `post_filter.sql`.

The post-filter examples `SET enable_seqscan = off` because the underfill is an index-scan failure
mode and the planner would otherwise pick a sequential scan on a table this small.
