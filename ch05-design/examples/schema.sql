-- A production-shaped RAG store: chunks of source documents, each with its
-- embedding co-located with the metadata you'll filter on.
DROP TABLE IF EXISTS chunks;
CREATE TABLE chunks (
    id           bigserial PRIMARY KEY,
    document_id  bigint      NOT NULL,
    chunk_text   text        NOT NULL,
    embedding    vector(1536) NOT NULL,
    source       text        NOT NULL,
    created_at   timestamptz NOT NULL DEFAULT now(),
    attributes   jsonb       NOT NULL DEFAULT '{}'
);

-- Native indexed columns for the fields you filter on most.
CREATE INDEX chunks_document_id_idx ON chunks (document_id);
CREATE INDEX chunks_source_idx      ON chunks (source);

-- Inspect the resulting table.
\d chunks
