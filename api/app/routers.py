from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List
from .database import get_db
from .models import OpenOrder, TopDeliveryDate, OpenProduct, TopCustomer
from .analytics import (
    get_open_orders,
    get_top_delivery_dates,
    get_open_products,
    get_top_customers,
)

router = APIRouter(prefix="/analytics")


@router.get("/orders", response_model=List[OpenOrder])
def read_open_orders(status: str = Query("open"), db: Session = Depends(get_db)):
    return get_open_orders(db)


@router.get("/orders/top", response_model=List[TopDeliveryDate])
def read_top_delivery_dates(limit: int = Query(3), db: Session = Depends(get_db)):
    return get_top_delivery_dates(db, limit)


@router.get("/orders/product", response_model=List[OpenProduct])
def read_open_products(db: Session = Depends(get_db)):
    return get_open_products(db)


@router.get("/orders/customers", response_model=List[TopCustomer])
def read_top_customers(
    status: str = Query("open"), limit: int = Query(3), db: Session = Depends(get_db)
):
    return get_top_customers(db, limit)
