CREATE TABLE
  intermediate.orders (
    version_id bigserial NOT NULL,
    order_id bigint NOT NULL,
    order_date date NULL,
    delivery_date date NULL,
    customer_id bigint NULL,
    status character varying NULL,
    updated_at timestamp(3) without time zone NULL,
    updated_by bigint NULL,
    created_at timestamp(3) without time zone NULL,
    created_by bigint NULL,
    effective_start timestamp with time zone NOT NULL,
    effective_end timestamp with time zone NULL,
    is_current boolean NOT NULL DEFAULT true,
    operation_type character(1) NOT NULL,
    change_timestamp timestamp with time zone NOT NULL
  );

ALTER TABLE
  intermediate.orders
ADD
  CONSTRAINT orders_pkey PRIMARY KEY (version_id)