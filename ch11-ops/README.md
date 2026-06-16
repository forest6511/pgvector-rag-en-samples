# Chapter 11 — Observability & production pitfalls

Companion code. PostgreSQL 18 + pgvector 0.8.2 via Docker.

## Run

```bash
docker compose up -d
docker compose exec -T db psql -U postgres -d ragdb < init.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/build_observe.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/recall.sql
docker compose down -v
```

## What it shows

`init.sql` loads 5,000 deterministic 128-d rows — enough that the index size is a real number.

- `build_observe.sql` — `CREATE INDEX CONCURRENTLY` (builds without locking writes) + the
  `pg_relation_size` reading that is the measurable form of the RAM wall. On this seed the HNSW
  index is ~4 MB. The `pg_stat_progress_create_index` query is shown commented because a 5k-row
  build finishes too fast to catch — run it from a second session on a real build.
- `recall.sql` — recall@k against exact (index-off) ground truth, captured into temp tables and
  compared. Returns 1.0 on this well-separated seed (a healthy result); the point is the mechanism
  you wire into CI so a config change that drops recall fails the build.
