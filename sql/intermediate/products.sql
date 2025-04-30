CREATE TABLE
  intermediate.products (
    version_id bigserial NOT NULL,
    product_id bigserial NOT NULL,
    product_name character varying(500) NOT NULL,
    barcode character varying(26) NOT NULL,
    unity_price numeric NOT NULL,
    is_active boolean NULL,
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
  intermediate.products
ADD
  CONSTRAINT products_pkey PRIMARY KEY (version_id)