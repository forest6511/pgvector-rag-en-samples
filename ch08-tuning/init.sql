-- Chapter 8: HNSW & IVFFlat tuning, iterative scans — setup
-- A deterministic 10k-row dataset large enough that the planner uses an ANN index, built for
-- COSINE distance (the book's default, matching Chapters 1/3/9). The status column is
-- deliberately ANTI-correlated with distance to the query so the post-filter problem
-- reproduces: the rows NEAREST the query are almost all 'archived'.

CREATE EXTENSION IF NOT EXISTS vector;

DROP TABLE IF EXISTS chunks;

CREATE TABLE chunks (
    id         bigserial PRIMARY KEY,
    status     text NOT NULL,
    embedding  vector(8)
);

-- 10,000 rows, no randomness (identical on every run). Each embedding points in a direction
-- set by an angle that grows with id: row i sits at angle (i/10000)*(pi/2) in the dim0/dim1
-- plane, so cosine distance to the query [1,0,0,...] grows with id. Small id = near (aligned
-- with the query direction), large id = far (rotated toward dim1). Dims 2..7 carry a tiny
-- deterministic component so vectors aren't perfectly collinear, without disturbing the order.
-- status is 'active' for a sparse ~1% of rows (every 100th id), so among the rows nearest the
-- query almost none are 'active' — which is what reproduces the post-filter underfill.
INSERT INTO chunks (status, embedding)
SELECT
    CASE WHEN i % 100 = 0 THEN 'active' ELSE 'archived' END AS status,
    (
        '[' ||
        cos((i::float / 10000.0) * (pi() / 2))       || ',' ||  -- dim0: 1 -> 0 as id grows
        sin((i::float / 10000.0) * (pi() / 2))       || ',' ||  -- dim1: 0 -> 1 as id grows
        (((i * 13) % 1000)::float / 100000.0)        || ',' ||  -- dims 2..7: tiny tie-breakers
        (((i * 17) % 1000)::float / 100000.0)        || ',' ||
        (((i * 19) % 1000)::float / 100000.0)        || ',' ||
        (((i * 23) % 1000)::float / 100000.0)        || ',' ||
        (((i * 29) % 1000)::float / 100000.0)        || ',' ||
        (((i * 31) % 1000)::float / 100000.0)        ||
        ']'
    )::vector AS embedding
FROM generate_series(0, 9999) AS i;
