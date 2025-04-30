-- Creating presentation layer views
CREATE OR REPLACE VIEW presentation.orders AS
SELECT
    order_id,
    order_date,
    delivery_date,
    customer_id,
    status,
    updated_at,
    updated_by,
    created_at,
    created_by
FROM intermediate.orders
WHERE is_current = true;

--
CREATE OR REPLACE VIEW presentation.order_items AS
SELECT
    order_item_id,
    order_id,
    product_id,
    quanity AS quantity,  -- Alias the typo'd column as 'quantity'
    updated_at,
    updated_by,
    created_at,
    created_by
FROM intermediate.order_items
WHERE is_current = true;