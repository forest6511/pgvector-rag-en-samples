# Chapter 5: table & vector type design

Runnable samples for *pgvector at Scale for PostgreSQL*, Chapter 5 — choosing a vector type
(`vector` / `halfvec` / `sparsevec` / `bit`) and designing the table your RAG store lives in.

## Environment

- Docker / Docker Compose
- PostgreSQL 18 + pgvector 0.8.2 (image `pgvector/pgvector:pg18`)

## Run

```bash
docker compose up -d
docker compose exec -T db psql -U postgres -d ragdb < init.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/storage_sizes.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/casting.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/schema.sql
docker compose down -v
```

## Files

- `compose.yaml` — PostgreSQL + pgvector
- `init.sql` — extension + a `type_demo` table holding the same 768-d vector as `vector` and `halfvec`
- `examples/storage_sizes.sql` — `pg_column_size()` showing the real byte cost of each type
- `examples/casting.sql` — `::halfvec` cast on a 3-d vector, showing half-precision rounding
- `examples/schema.sql` — the production `chunks` RAG-store table with native + jsonb metadata
