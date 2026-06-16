-- Chapter 12: pgvectorscale's diskann index (StreamingDiskANN + SBQ).
-- Runs on a pgvectorscale-capable image (timescale/timescaledb-ha), NOT stock RDS.
-- AlloyDB ScaNN and the dedicated-DB migrations in the chapter are managed/external and shown
-- from official docs, not run here.

CREATE EXTENSION IF NOT EXISTS vectorscale CASCADE;  -- pulls in pgvector

DROP TABLE IF EXISTS chunks;
CREATE TABLE chunks (id bigserial PRIMARY KEY, embedding vector(128));
INSERT INTO chunks (id, embedding)
SELECT g.id,
       (SELECT array_agg(sin((d * (g.id + 1))::float / 20.0))::vector
        FROM generate_series(1, 128) AS d)
FROM generate_series(0, 999) AS g(id);

-- StreamingDiskANN index. With the default memory_optimized storage layout, SBQ is on
-- automatically (the build NOTICE reports storage_layout=SbqCompression).
CREATE INDEX chunks_diskann_idx ON chunks USING diskann (embedding vector_cosine_ops);

-- query_rescore is the exact-rerank depth (the SBQ candidate stage is approximate).
SET diskann.query_rescore = 100;

EXPLAIN (COSTS OFF)
SELECT id FROM chunks
ORDER BY embedding <=> (SELECT embedding FROM chunks WHERE id = 500)
LIMIT 10;
