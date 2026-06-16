-- Cast a vector to halfvec and back, on a small 3-d example so the values
-- are readable. Half precision keeps ~3 significant digits.
SELECT
    '[0.123456, 0.654321, 0.111111]'::vector(3)              AS original,
    '[0.123456, 0.654321, 0.111111]'::vector(3)::halfvec(3) AS as_halfvec;
