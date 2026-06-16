# Chapter 12 — When Postgres isn't enough: pgvectorscale, AlloyDB ScaNN, migrating off

Mostly a decision chapter. The one runnable piece is pgvectorscale, which needs a Timescale image
(it bundles pgvector + the `vectorscale` extension). AlloyDB ScaNN and the dedicated-DB migrations
are managed/external and described from official docs — never faked output.

## Run

```bash
docker compose up -d
docker compose exec -T db psql -U postgres -d ragdb < examples/pgvectorscale.sql
docker compose down -v
```

## Verified at time of writing

`timescale/timescaledb-ha:pg17` ships pgvector **0.8.2** + pgvectorscale **0.9.0**.
`CREATE EXTENSION vectorscale CASCADE` installs pgvector automatically; the `diskann` index builds
with SBQ on by default (build NOTICE: `storage_layout=SbqCompression`); `diskann.query_rescore`
is accepted; `EXPLAIN` shows `Index Scan using chunks_diskann_idx`. Confirms the chapter's claims
that diskann + automatic SBQ + a tunable rerank are real and run on Postgres.
