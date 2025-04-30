from sqlalchemy.orm import Session
from sqlalchemy import text


def get_open_orders(db: Session):
    query = """
    select
        delivery_date,
        status,
        count(1) quantity
    from
        presentation.orders
    where
        status <> 'COMPLETED'
    group by
        delivery_date,
        status
    """
    return db.execute(text(query)).fetchall()


def get_top_delivery_dates(db: Session, limit: int):
    query = f"""
    select
        delivery_date,
        count(1) quantity
    from
        presentation.orders
    where
        status <> 'COMPLETED'
    group by
        delivery_date
    order by 
        quantity desc
    limit {limit}
    """
    return db.execute(text(query)).fetchall()


def get_open_products(db: Session):
    query = """
    select
        oi.product_id,
        sum(oi.quantity) total_items
    from
        presentation.order_items oi
    join
        presentation.orders o
        on oi.order_id = o.order_id
    where 
        o.status <> 'COMPLETED'
    group by
        oi.product_id
    order by
        total_items desc,
        oi.product_id;
    """
    return db.execute(text(query)).fetchall()


def get_top_customers(db: Session, limit: int):
    query = f"""
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
        ranking <= {limit}
        ORDER BY
        ranking,
        customer_id;
    """
    return db.execute(text(query)).fetchall()
