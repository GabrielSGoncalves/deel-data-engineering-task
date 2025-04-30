-- Analytical queries required by the Logistics Leader
-- Number of open orders by DELIVERY_DATE and STATUS
select
	delivery_date,
  status,
  count(1) quantity
from
	presentation.orders
where
	status != 'COMPLETED'
group by
	delivery_date,
  status
;

-- Top 3 delivery dates with more open orders
select
	delivery_date,
  count(1) quantity
from
	presentation.orders
where
	status != 'COMPLETED'
group by
  delivery_date
order by 
	quantity desc
limit 3
;

-- Number of open pending items by PRODUCT_ID, this information can be queried using
-- the order status and the order items
select
  oi.product_id,
  sum(oi.quanity) total_items
from
	presentation.order_items oi
join
	presentation.orders o
	on oi.order_id = o.order_id
where 1=1
	--and o.status != 'COMPLETED'
group by
	oi.product_id
order by
	total_items desc,
  oi.product_id
;

-- Top 3 Customers with more pending orders
WITH customer_pending_orders AS (
  SELECT
    c.customer_id,
    c.customer_name,
    COUNT(*) AS quantity
  FROM
    presentation.orders o
    JOIN presentation.customers c ON o.customer_id = c.customer_id
  WHERE
    o.status = 'PENDING'
  GROUP BY
    c.customer_id,
    c.customer_name
),
ranked_customers AS (
  SELECT
    customer_id,
    customer_name,
    quantity,
    DENSE_RANK() OVER (ORDER BY quantity DESC) AS ranking
  FROM
    customer_pending_orders
)
SELECT
  customer_id,
  customer_name,
  quantity,
  ranking
FROM
  ranked_customers
WHERE
  ranking <= 3
ORDER BY
  ranking,
  customer_id;