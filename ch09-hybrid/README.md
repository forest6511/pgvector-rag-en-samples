# Chapter 9 — Hybrid search: tsvector vs ParadeDB pg_search (BM25) + RRF

Companion code for the chapter. Two Postgres images, because real BM25 needs ParadeDB.

- `db` (stock `pgvector/pgvector:pg18`, port 5432) — tsvector keyword search + the RRF fusion query.
- `paradedb` (`paradedb/paradedb:latest`, port 5433) — the `pg_search` BM25 examples.

## Run

```bash
docker compose up -d

# tsvector + RRF on stock Postgres
docker compose exec -T db psql -U postgres -d ragdb < init.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/tsvector_rrf.sql

# real BM25 on ParadeDB
docker compose exec -T paradedb psql -U postgres -d ragdb < init.sql
docker compose exec -T paradedb psql -U postgres -d ragdb < examples/bm25.sql

docker compose down -v
```

## What the dataset does

`init.sql` loads six short, deterministic docs about vehicles and cooking. Row 6 is the keyword
trap: it literally contains "automobile" but is about cooking. The query "automobile" makes the two
retrieval strategies disagree — keyword search ranks the cooking row high, the vector leg pushes it
down, and RRF fusion lands the actual vehicle doc on top. That's the chapter's argument for hybrid
search in one query.

Verified at time of writing: pg_search **0.24.0** (ParadeDB latest), `@@@` match operator,
`pdb.score(id)` BM25 score.
