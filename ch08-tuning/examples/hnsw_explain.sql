-- Chapter 8: HNSW build, ef_search, and the EXPLAIN plan shape.
-- Run after init.sql. Cosine distance, matching the book's default.

CREATE INDEX chunks_embedding_idx ON chunks USING hnsw (embedding vector_cosine_ops);

SET hnsw.ef_search = 40;

-- Plain top-10, no filter: the planner uses the HNSW index.
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF, BUFFERS OFF)
SELECT id FROM chunks
ORDER BY embedding <=> '[1,0,0,0,0,0,0,0]'::vector
LIMIT 10;
