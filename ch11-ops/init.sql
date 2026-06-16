-- Chapter 11: observability & pitfalls — setup.
-- Enough 128-d rows that the index size is a real, non-trivial number to read with
-- pg_relation_size. Deterministic (no randomness) so the recall demo is reproducible.

CREATE EXTENSION IF NOT EXISTS vector;

DROP TABLE IF EXISTS chunks;

CREATE TABLE chunks (
    id        bigserial PRIMARY KEY,
    embedding vector(128)
);

INSERT INTO chunks (id, embedding)
SELECT
    g.id,
    (
        SELECT array_agg(sin((d * (g.id + 1))::float / 20.0))::vector
        FROM generate_series(1, 128) AS d
    )
FROM generate_series(0, 4999) AS g(id);
