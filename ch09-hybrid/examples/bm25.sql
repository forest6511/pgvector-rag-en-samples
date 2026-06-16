-- Chapter 9: real BM25 with ParadeDB pg_search.
-- Run against the `paradedb` service (port 5433), NOT stock Postgres — pg_search needs the
-- ParadeDB image. Load init.sql into this service first (it has pgvector too).

CREATE EXTENSION IF NOT EXISTS pg_search;

-- Confirm the installed version (don't pin a number in prose beyond "at time of writing").
SELECT extversion FROM pg_extension WHERE extname = 'pg_search';

CREATE INDEX search_idx ON chunks
    USING bm25 (id, chunk_text)
    WITH (key_field = 'id');

-- BM25 query: @@@ match operator, pdb.score() for the score.
SELECT id, pdb.score(id) AS score, chunk_text
FROM chunks
WHERE chunk_text @@@ 'automobile'
ORDER BY score DESC
LIMIT 10;
