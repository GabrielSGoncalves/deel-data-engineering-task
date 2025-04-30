from sqlalchemy.orm import Session
from sqlalchemy import text


def get_open_orders(db: Session):
    query = """
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
    """
    return db.execute(text(query)).fetchall()


def get_top_delivery_dates(db: Session, limit: int):
    query = f"""
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
    limit {limit}
    """
    return db.execute(text(query)).fetchall()


def get_open_products(db: Session):
    query = """
    select
        oi.product_id,
        sum(oi.quanity) total_items
    from
        operations.order_items oi
    join
        operations.orders o
        on oi.order_id = o.order_id
    where
        o.status != 'COMPLETED'
    group by
        oi.product_id
    order by
        total_items desc,
        oi.product_id
    """
    return db.execute(text(query)).fetchall()


def get_top_customers(db: Session, limit: int):
    query = f"""
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
    limit {limit}
    """
    return db.execute(text(query)).fetchall()
