from pydantic import BaseModel
from typing import List
from datetime import date


class OpenOrder(BaseModel):
    delivery_date: date
    status: str
    quantity: int


class TopDeliveryDate(BaseModel):
    delivery_date: date
    quantity: int


class OpenProduct(BaseModel):
    product_id: int
    total_items: int


class TopCustomer(BaseModel):
    customer_id: int
    customer_name: str
    quantity: int
