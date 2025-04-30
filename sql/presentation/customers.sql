CREATE OR REPLACE VIEW
  "presentation"."customers" AS
SELECT
  customers.customer_id,
  customers.customer_name,
  customers.is_active,
  customers.customer_address,
  customers.updated_at,
  customers.updated_by,
  customers.created_at,
  customers.created_by
FROM
  intermediate.customers
WHERE
  customers.is_current = true;