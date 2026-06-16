-- Chapter 10: the two-stage binary-quantization query (candidate retrieval + exact rerank).
-- Run after init.sql. Demonstrates that the two-stage result matches exact search on this seed,
-- which is the recall claim the chapter makes.

-- Expression index over the binary representation so the candidate stage uses an index.
CREATE INDEX chunks_bq_idx ON chunks
    USING hnsw ((binary_quantize(embedding)::bit(768)) bit_hamming_ops);

-- Query vector = row 500's embedding (so the true nearest neighbor is id 500 itself).
-- Two-stage: wide binary candidate pool, then exact cosine rerank.
WITH q AS (SELECT embedding AS v FROM chunks WHERE id = 500)
SELECT id
FROM (
    SELECT c.id, c.embedding
    FROM chunks c, q
    ORDER BY binary_quantize(c.embedding)::bit(768) <~> binary_quantize(q.v)
    LIMIT 100
) candidates, q
ORDER BY candidates.embedding <=> q.v
LIMIT 10;

-- Compare against exact (no binary stage): the top-10 should match.
WITH q AS (SELECT embedding AS v FROM chunks WHERE id = 500)
SELECT id
FROM chunks c, q
ORDER BY c.embedding <=> q.v
LIMIT 10;
