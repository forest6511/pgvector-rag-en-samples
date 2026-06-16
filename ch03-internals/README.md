# Chapter 3: pgvector internals

Runnable samples for *pgvector at Scale for PostgreSQL*, Chapter 3 — how pgvector stores and
searches vectors: types, distance operators, and the HNSW vs IVFFlat indexes.

## Environment

- Docker / Docker Compose
- PostgreSQL 18 + pgvector 0.8.2 (image `pgvector/pgvector:pg18`)

## Run

```bash
docker compose up -d
docker compose exec -T db psql -U postgres -d ragdb < init.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/01_types.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/02_distance_ops.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/03_hnsw.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/05_scale_and_index.sql
# IVFFlat demo on the clean seed table:
docker compose exec -T db psql -U postgres -d ragdb < init.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/04_ivfflat.sql
docker compose down -v
```

## Files

- `compose.yaml` — PostgreSQL + pgvector
- `init.sql` — extension + a tiny 6-row `documents` table (3-d vectors)
- `examples/01_types.sql` — the stored type and the `inner_product` helper
- `examples/02_distance_ops.sql` — L2 / cosine / negative-inner-product operators
- `examples/03_hnsw.sql` — build an HNSW index (seq scan on the tiny table — that's correct)
- `examples/05_scale_and_index.sql` — add 10k rows so the planner uses the HNSW index
- `examples/04_ivfflat.sql` — IVFFlat must be built after loading data
