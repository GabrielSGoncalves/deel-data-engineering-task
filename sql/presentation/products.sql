CREATE OR REPLACE VIEW
  "presentation"."products" AS
SELECT
  products.product_id,
  products.product_name,
  products.barcode,
  products.unity_price,
  products.is_active,
  products.updated_at,
  products.updated_by,
  products.created_at,
  products.created_by
FROM
  intermediate.products
WHERE
  products.is_current = true;