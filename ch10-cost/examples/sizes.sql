-- Chapter 10: measured bytes-per-vector for each representation. Run after init.sql.
-- These are pg_column_size values (the real stored size, including overhead), not the formula.
SELECT
  pg_column_size(embedding)                            AS vector_bytes,
  pg_column_size(embedding::halfvec(768))              AS halfvec_bytes,
  pg_column_size(binary_quantize(embedding)::bit(768)) AS bit_bytes
FROM chunks WHERE id = 1;
