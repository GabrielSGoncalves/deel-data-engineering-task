from pydantic import BaseModel
from typing import List


class OpenOrder(BaseModel):
    delivery_date: str
    status: str
    quantity: int


class TopDeliveryDate(BaseModel):
    delivery_date: str
    quantity: int


class OpenProduct(BaseModel):
    product_id: int
    total_items: int


class TopCustomer(BaseModel):
    customer_id: int
    customer_name: str
    quantity: int
