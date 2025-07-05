use missing_millions;

INSERT INTO transactions (txn_id, sender_id, receiver_id, amount, txn_time, location)
VALUES 
  ('T30001', 'U9011', 'U9012', 500, '2025-07-01 10:00:00', 'Hyderabad'),
  ('T30002', 'U9012', 'U9013', 500, '2025-07-01 10:05:00', 'Hyderabad'),
  ('T30003', 'U9013', 'U9011', 500, '2025-07-01 10:10:00', 'Hyderabad');


WITH RECURSIVE ring AS (
  SELECT
    sender_id,
    receiver_id,
    sender_id AS origin,
    txn_id,
    txn_time,
    1 AS depth,
    CAST(sender_id AS CHAR(100)) AS path
  FROM (
    SELECT *
    FROM transactions
    ORDER BY txn_time
    -- LIMIT removed temporarily
  ) AS base

  UNION ALL

  SELECT
    t.sender_id,
    t.receiver_id,
    ring.origin,
    t.txn_id,
    t.txn_time,
    ring.depth + 1,
    CONCAT(ring.path, ' → ', t.receiver_id)
  FROM ring
  JOIN transactions t ON ring.receiver_id = t.sender_id
  WHERE ring.depth < 4
    AND NOT FIND_IN_SET(t.receiver_id, ring.path)
)

SELECT *
FROM ring
WHERE sender_id = receiver_id AND depth > 2;
