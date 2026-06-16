-- Ch3: build an HNSW index. On a tiny table the planner still prefers a seq scan,
-- because scanning 6 rows is cheaper than walking an index. That's correct behavior.
-- Operator class must match the query operator: a cosine index accelerates <=> queries.

CREATE INDEX ON documents USING hnsw (embedding vector_cosine_ops)
    WITH (m = 16, ef_construction = 64);

-- Query-time recall/speed knob (default 40).
SET hnsw.ef_search = 40;

-- The ORDER BY ... <=> ... LIMIT shape is what lets the index be used.
-- With only 6 rows, expect a Seq Scan (the planner is right to skip the index).
EXPLAIN (COSTS OFF)
SELECT title FROM documents
ORDER BY embedding <=> '[1,0,0]'::vector
LIMIT 3;
