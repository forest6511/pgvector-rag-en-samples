-- Chapter 5: vector type design.
CREATE EXTENSION IF NOT EXISTS vector;

-- A table with the same logical 768-d vector stored four different ways,
-- so we can measure the storage cost of each type.
DROP TABLE IF EXISTS type_demo;
CREATE TABLE type_demo (
    id           bigserial PRIMARY KEY,
    as_vector    vector(768),
    as_halfvec   halfvec(768)
);

-- One row, same data in both columns (a vector of all 0.1s).
INSERT INTO type_demo (as_vector, as_halfvec)
SELECT v, v::halfvec(768)
FROM (
    SELECT ('[' || array_to_string(array_fill(0.1::real, ARRAY[768]), ',') || ']')::vector(768) AS v
) s;
