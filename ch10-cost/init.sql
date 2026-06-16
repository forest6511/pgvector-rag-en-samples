-- Chapter 10: cost engineering — setup.
-- 768-dimension vectors so byte sizes match the book's figures (vector(768) vs halfvec(768)
-- vs binary_quantize::bit(768)). 1,000 deterministic rows: each row's components are a stable
-- function of (id, dimension), no randomness, so sizes and the rerank demo are reproducible.

CREATE EXTENSION IF NOT EXISTS vector;

DROP TABLE IF EXISTS chunks;

CREATE TABLE chunks (
    id        bigserial PRIMARY KEY,
    embedding vector(768)
);

-- Build each 768-d vector from a per-row seed. Components spread across [-1, 1] via a sine of
-- (dimension * id), giving 1,000 distinct, well-separated directions.
INSERT INTO chunks (id, embedding)
SELECT
    g.id,
    (
        SELECT array_agg(sin((d * (g.id + 1))::float / 50.0))::vector
        FROM generate_series(1, 768) AS d
    )
FROM generate_series(0, 999) AS g(id);
