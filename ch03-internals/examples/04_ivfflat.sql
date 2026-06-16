-- Ch3: IVFFlat must be built AFTER the table has data (it clusters existing rows).
-- A separate L2 index. On the tiny seed table, expect a Seq Scan again — same reason
-- as HNSW: with 6 rows the planner skips the index. The point here is the build rule,
-- not the plan: build IVFFlat after loading, because it k-means-clusters what's there.

CREATE INDEX ON documents USING ivfflat (embedding vector_l2_ops)
    WITH (lists = 2);

-- Query-time knob: how many lists (clusters) to probe (default 1).
SET ivfflat.probes = 2;

EXPLAIN (COSTS OFF)
SELECT title FROM documents
ORDER BY embedding <-> '[1,0,0]'::vector
LIMIT 3;
