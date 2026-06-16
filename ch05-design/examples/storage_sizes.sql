-- Measure the on-disk size of each vector type for the same 768-d vector.
-- vector  = 4 bytes/dim + overhead;  halfvec = 2 bytes/dim + overhead.
SELECT
    pg_column_size(as_vector)  AS vector_bytes,
    pg_column_size(as_halfvec) AS halfvec_bytes
FROM type_demo;
