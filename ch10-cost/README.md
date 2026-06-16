# Chapter 10 — Cost engineering: halfvec, binary quantization, the RAM wall

Companion code. PostgreSQL 18 + pgvector 0.8.2 via Docker.

## Run

```bash
docker compose up -d
docker compose exec -T db psql -U postgres -d ragdb < init.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/sizes.sql
docker compose exec -T db psql -U postgres -d ragdb < examples/binary_rerank.sql
docker compose down -v
```

## What it shows

`init.sql` loads 1,000 deterministic 768-dimension vectors (so byte sizes match the book).

- `sizes.sql` — measured bytes per representation: `vector(768)` = 3076, `halfvec(768)` = 1544
  (~half), `binary_quantize(embedding)::bit(768)` = 104 (96 bytes of bits + 8-byte length header).
- `binary_rerank.sql` — the two-stage binary query (wide Hamming candidate pool → exact cosine
  rerank) returns the same top-10 as exact search on this seed (recall@10 = 1.0), which is the
  chapter's claim that the rerank restores quality the binary stage alone would lose.
