CREATE OR REPLACE VIEW
  "presentation"."order_items" AS
SELECT
  order_items.order_item_id,
  order_items.order_id,
  order_items.product_id,
  order_items.quanity AS quantity,
  order_items.updated_at,
  order_items.updated_by,
  order_items.created_at,
  order_items.created_by
FROM
  intermediate.order_items
WHERE
  order_items.is_current = true;