-- Chapter 8: the post-filter underfill problem and the iterative-scan fix.
-- Run after init.sql and hnsw_explain.sql (which builds the index).
-- The underfill is an index-scan failure mode, so we force the index with enable_seqscan = off
-- to observe it deterministically on a small table (in production the index scan is what you want).

SET hnsw.ef_search = 40;
SET enable_seqscan = off;

-- (1) Post-filter, iterative scan OFF: the index returns 40 candidates by distance, the WHERE
--     removes the non-active ones, and you get fewer rows than the LIMIT asked for.
SET hnsw.iterative_scan = off;
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF, BUFFERS OFF)
SELECT id FROM chunks
WHERE status = 'active'
ORDER BY embedding <=> '[1,0,0,0,0,0,0,0]'::vector
LIMIT 10;

-- (2) Iterative scan ON (strict_order): the scan re-probes until the LIMIT is satisfied.
SET hnsw.iterative_scan = 'strict_order';
EXPLAIN (ANALYZE, COSTS OFF, TIMING OFF, SUMMARY OFF, BUFFERS OFF)
SELECT id FROM chunks
WHERE status = 'active'
ORDER BY embedding <=> '[1,0,0,0,0,0,0,0]'::vector
LIMIT 10;
