-- Chapter 11: build the index, then read its size.
-- (pg_stat_progress_create_index must be queried from a SECOND session while the build runs;
--  on a 5k-row table the build is too fast to catch, so the progress query is shown for
--  reference and exercised separately.)

CREATE INDEX CONCURRENTLY chunks_embedding_idx ON chunks
    USING hnsw (embedding vector_cosine_ops);

-- The number that defines the RAM wall: how big is the index?
SELECT pg_size_pretty(pg_relation_size('chunks_embedding_idx')) AS index_size;

-- Progress query (run from another session during a long build):
-- SELECT phase, round(100.0 * blocks_done / nullif(blocks_total, 0), 1) AS pct
-- FROM pg_stat_progress_create_index;
