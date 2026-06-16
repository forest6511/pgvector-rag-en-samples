-- Chapter 9: hybrid search (tsvector + vector + RRF) — setup.
-- A tiny, deterministic corpus where keyword and semantic retrieval disagree, so hybrid
-- fusion visibly beats either leg alone. Embeddings are hand-set 4-d vectors standing in for
-- a "topic" direction (the real ones come from Chapter 6's model).

CREATE EXTENSION IF NOT EXISTS vector;

DROP TABLE IF EXISTS chunks;

CREATE TABLE chunks (
    id         bigserial PRIMARY KEY,
    chunk_text text NOT NULL,
    embedding  vector(4)
);

-- Topic axis: dim0 ~ "vehicles", dim1 ~ "cooking". The query "automobile" is semantically a
-- vehicle but the exact token only appears in some rows; "car" is the synonym keyword search
-- would miss without the vector leg.
INSERT INTO chunks (chunk_text, embedding) VALUES
    ('A car is a wheeled motor vehicle used for transportation.',  '[0.9, 0.1, 0.0, 0.0]'),
    ('The automobile industry shifted toward electric drivetrains.', '[0.85, 0.1, 0.05, 0.0]'),
    ('Modern vehicles rely on lithium-ion battery packs.',          '[0.8, 0.0, 0.2, 0.0]'),
    ('A sedan and a hatchback are common car body styles.',         '[0.88, 0.05, 0.07, 0.0]'),
    ('Braising is a slow cooking method for tough cuts of meat.',   '[0.1, 0.9, 0.0, 0.0]'),
    ('The recipe calls for two cups of automobile-grade flour.',    '[0.05, 0.92, 0.03, 0.0]');
-- Row 6 is the keyword trap: it literally contains "automobile" but is about cooking, so
-- pure keyword search ranks it high while the vector leg correctly pushes it down.

-- Stored tsvector + GIN index (the production shape, not computed per query).
ALTER TABLE chunks
    ADD COLUMN tsv tsvector
    GENERATED ALWAYS AS (to_tsvector('english', chunk_text)) STORED;

CREATE INDEX chunks_tsv_idx ON chunks USING gin (tsv);
