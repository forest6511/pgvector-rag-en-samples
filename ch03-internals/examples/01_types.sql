-- Ch3: vector types and the inner_product helper.

-- The stored column is vector(3); inspect it.
\d documents

-- inner_product (dot product) is a plain function you can call directly.
SELECT inner_product('[1,2,3]'::vector, '[4,5,6]'::vector) AS dot;
