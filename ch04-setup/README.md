# Chapter 4: setup across the ecosystem

Runnable samples for *pgvector at Scale for PostgreSQL*, Chapter 4 — installing pgvector locally
and reaching it through the Supabase `vecs` client. The managed-service blocks in the chapter
(RDS, Neon, AlloyDB) are syntax shown against their own clouds and aren't reproduced here.

## Environment

- Docker / Docker Compose
- PostgreSQL 18 + pgvector 0.8.2 (image `pgvector/pgvector:pg18`)
- Python 3 (for the `vecs` example)

## Run

```bash
docker compose up -d
docker compose exec -T db psql -U postgres -d ragdb < init.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/verify.sql

python3 -m venv .venv
.venv/bin/pip install vecs
.venv/bin/python examples/vecs_quickstart.py

docker compose down -v
```

## Files

- `compose.yaml` — PostgreSQL + pgvector, with `shm_size: 1g` for parallel HNSW builds
- `init.sql` — `CREATE EXTENSION vector` + a tiny smoke table
- `examples/verify.sql` — print the installed version and run a nearest-neighbor query
- `examples/vecs_quickstart.py` — the Supabase `vecs` collection API against the local container
