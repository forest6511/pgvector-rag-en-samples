-- Chapter 4: turn pgvector on, smoke-test that it works.
CREATE EXTENSION IF NOT EXISTS vector;

-- A minimal table proving the vector type is usable after install.
DROP TABLE IF EXISTS items;
CREATE TABLE items (
    id        bigserial PRIMARY KEY,
    embedding vector(3)
);

INSERT INTO items (embedding) VALUES
    ('[1,0,0]'),
    ('[0,1,0]'),
    ('[0,0,1]');
