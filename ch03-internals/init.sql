-- Chapter 3: pgvector internals — setup
-- A tiny, deterministic dataset so the output in the book is stable and readable.

CREATE EXTENSION IF NOT EXISTS vector;

DROP TABLE IF EXISTS documents;

CREATE TABLE documents (
    id        bigserial PRIMARY KEY,
    title     text NOT NULL,
    embedding vector(3)        -- 3 dims: small enough to read, real enough to search
);

-- Six points in 3-D space. The first three cluster near [1,0,0]; the last three near [0,0,1].
INSERT INTO documents (title, embedding) VALUES
    ('a', '[1.0, 0.1, 0.0]'),
    ('b', '[0.9, 0.2, 0.1]'),
    ('c', '[0.8, 0.0, 0.2]'),
    ('d', '[0.1, 0.0, 1.0]'),
    ('e', '[0.0, 0.2, 0.9]'),
    ('f', '[0.2, 0.1, 0.8]');
