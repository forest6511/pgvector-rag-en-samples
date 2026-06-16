-- Ch3: the four distance operators, querying near [1,0,0].
-- Smaller distance = more similar, so ORDER BY ... ASC puts nearest first.

-- L2 (Euclidean) distance
SELECT title, embedding <-> '[1,0,0]'::vector AS l2
FROM documents ORDER BY l2 LIMIT 3;

-- Cosine distance (1 - cosine similarity)
SELECT title, embedding <=> '[1,0,0]'::vector AS cosine
FROM documents ORDER BY cosine LIMIT 3;

-- Negative inner product (so ascending = nearest, like the others)
SELECT title, embedding <#> '[1,0,0]'::vector AS neg_ip
FROM documents ORDER BY neg_ip LIMIT 3;
