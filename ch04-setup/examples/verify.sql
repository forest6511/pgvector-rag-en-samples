-- Confirm which pgvector version is actually installed.
SELECT extname, extversion FROM pg_extension WHERE extname = 'vector';

-- A nearest-neighbor query proving the extension works end to end.
SELECT id, embedding, embedding <=> '[1,0,0]' AS cosine_distance
FROM items
ORDER BY embedding <=> '[1,0,0]'
LIMIT 3;
