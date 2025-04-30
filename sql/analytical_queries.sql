-- Analytical queries required by the Logistics Leader
-- Number of open orders by DELIVERY_DATE and STATUS
select
	delivery_date,
  status,
  count(1) quantity
from
	operations.orders
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
	operations.orders
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
	operations.order_items oi
join
	operations.orders o
	on oi.order_id = o.order_id
where 1=1
	and o.status != 'COMPLETED'
group by
	oi.product_id
order by
	total_items desc,
  oi.product_id
;

-- Top 3 Customers with more pending orders
select
	c.customer_id,
  c.customer_name,
  count(1) quantity
from
	operations.orders o
join
	operations.customers c
	on o.customer_id = c.customer_id
where
	o.status != 'COMPLETED'
group by
	c.customer_id,
  c.customer_name
order by
	quantity desc,
  customer_id
  ;