CREATE TABLE
  intermediate.order_items (
    version_id bigserial NOT NULL,
    order_item_id bigserial NOT NULL,
    order_id bigint NULL,
    product_id bigint NULL,
    quanity integer NULL,
    updated_at timestamp(3) without time zone NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_by bigint NULL,
    created_at timestamp(3) without time zone NULL DEFAULT CURRENT_TIMESTAMP(3),
    created_by bigint NULL,
    effective_start timestamp with time zone NOT NULL,
    effective_end timestamp with time zone NULL,
    is_current boolean NOT NULL DEFAULT true,
    operation_type character(1) NOT NULL,
    change_timestamp timestamp with time zone NOT NULL
  );

ALTER TABLE
  intermediate.order_items
ADD
  CONSTRAINT order_items_pkey PRIMARY KEY (version_id)