-- Chapter 9: tsvector keyword search and RRF fusion on stock PostgreSQL + pgvector.
-- Run after init.sql. Query: "automobile" — a vehicle (semantic) whose exact token also
-- appears in a cooking sentence (the keyword trap).

-- Keyword leg alone: ts_rank ranks the keyword-trap cooking row near the top.
SELECT id, chunk_text
FROM chunks, to_tsquery('english', 'automobile') query
WHERE tsv @@ query
ORDER BY ts_rank(tsv, query) DESC;

-- RRF fusion of the vector leg (semantic vehicle direction) and the keyword leg.
WITH vector_results AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY embedding <=> '[0.9,0.1,0,0]'::vector) AS rank
    FROM chunks
    ORDER BY embedding <=> '[0.9,0.1,0,0]'::vector
    LIMIT 20
),
keyword_results AS (
    SELECT id, ROW_NUMBER() OVER (ORDER BY ts_rank(tsv, query) DESC) AS rank
    FROM chunks, to_tsquery('english', 'automobile') query
    WHERE tsv @@ query
    ORDER BY ts_rank(tsv, query) DESC
    LIMIT 20
)
SELECT id, round(SUM(1.0 / (60 + rank))::numeric, 5) AS rrf_score
FROM (
    SELECT id, rank FROM vector_results
    UNION ALL
    SELECT id, rank FROM keyword_results
) fused
GROUP BY id
ORDER BY rrf_score DESC
LIMIT 10;
