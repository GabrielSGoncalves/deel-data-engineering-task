CREATE OR REPLACE VIEW
  "presentation"."orders" AS
SELECT
  orders.order_id,
  orders.order_date,
  orders.delivery_date,
  orders.customer_id,
  orders.status,
  orders.updated_at,
  orders.updated_by,
  orders.created_at,
  orders.created_by
FROM
  intermediate.orders
WHERE
  orders.is_current = true;