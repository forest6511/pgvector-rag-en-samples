-- Chapter 11: recall@k against exact ground truth.
-- Exact = brute force with the index disabled. ANN = the same query under the index. A SET can't
-- live inside a CTE, so capture each result set into a TEMP TABLE and compare. Run after
-- build_observe.sql (which builds the index). Query vector = row 2500's embedding.

-- Exact top-20 (no index): the ground truth.
SET enable_indexscan = off;
SET enable_bitmapscan = off;
CREATE TEMP TABLE exact20 AS
WITH q AS (SELECT embedding AS v FROM chunks WHERE id = 2500)
SELECT c.id FROM chunks c, q ORDER BY c.embedding <=> q.v LIMIT 20;
RESET enable_indexscan;
RESET enable_bitmapscan;

-- ANN top-20 under the index at the ef_search you ship.
SET hnsw.ef_search = 100;
CREATE TEMP TABLE ann20 AS
WITH q AS (SELECT embedding AS v FROM chunks WHERE id = 2500)
SELECT c.id FROM chunks c, q ORDER BY c.embedding <=> q.v LIMIT 20;

-- recall@20 = overlap / k. Healthy settings on a well-separated corpus return 1.0; drop
-- ef_search far enough (or use a denser corpus) and this falls below 1.0 — which is exactly
-- the regression a recall CI catches before it ships.
SELECT (SELECT count(*) FROM ann20 WHERE id IN (SELECT id FROM exact20))::float / 20
       AS recall_at_20;

DROP TABLE exact20;
DROP TABLE ann20;
