-- Ch3: give the planner a reason to use the HNSW index by adding 10,000 rows.
-- setseed makes the random data reproducible, so the plan is the same every run.
-- Run init.sql + 03_hnsw.sql first (the cosine HNSW index must already exist).

SELECT setseed(0.42);

INSERT INTO documents (title, embedding)
SELECT 'r' || g,
       ('[' || random() || ',' || random() || ',' || random() || ']')::vector
FROM generate_series(1, 10000) g;

-- Refresh planner statistics so it knows the table is now large.
ANALYZE documents;

SET hnsw.ef_search = 40;

-- Now expect an Index Scan using the HNSW index.
EXPLAIN (COSTS OFF)
SELECT title FROM documents
ORDER BY embedding <=> '[1,0,0]'::vector
LIMIT 3;
