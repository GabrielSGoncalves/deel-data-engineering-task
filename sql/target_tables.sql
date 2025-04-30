-- DDLs and resource creation
create schema raw;
create schema intermediate;
create schema presentation;

-- Creating the SCD type 2 tables
-- orders
CREATE TABLE intermediate.orders (
    version_id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    order_date DATE,
    delivery_date DATE,
    customer_id BIGINT,
    status VARCHAR,
    updated_at TIMESTAMP(3),
    updated_by BIGINT,
    created_at TIMESTAMP(3),
    created_by BIGINT,
    effective_start TIMESTAMPTZ NOT NULL,
    effective_end TIMESTAMPTZ,
    is_current BOOLEAN NOT NULL DEFAULT true,
    operation_type CHAR(1) NOT NULL CHECK (operation_type IN ('I','U','D')),
    change_timestamp TIMESTAMPTZ NOT NULL
);

CREATE INDEX ON intermediate.orders (order_id);
CREATE INDEX ON intermediate.orders (is_current);
CREATE INDEX ON intermediate.orders (change_timestamp);

-- order_items
CREATE TABLE intermediate.order_items (
  	version_id BIGSERIAL PRIMARY KEY,
    order_item_id bigserial NOT NULL,
    order_id bigint NULL,
    product_id bigint NULL,
    quanity integer NULL,
    updated_at timestamp(3) without time zone NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_by bigint NULL,
    created_at timestamp(3) without time zone NULL DEFAULT CURRENT_TIMESTAMP(3),
    created_by bigint NULL,
  	effective_start TIMESTAMPTZ NOT NULL,
    effective_end TIMESTAMPTZ,
    is_current BOOLEAN NOT NULL DEFAULT true,
    operation_type CHAR(1) NOT NULL CHECK (operation_type IN ('I','U','D')),
    change_timestamp TIMESTAMPTZ NOT NULL
  );

CREATE INDEX ON intermediate.order_items (order_id);
CREATE INDEX ON intermediate.order_items (is_current);
CREATE INDEX ON intermediate.order_items (change_timestamp);

-- customers
--DROP TABLE intermediate.customers;
CREATE TABLE intermediate.customers (
    version_id BIGSERIAL PRIMARY KEY,
    customer_id bigserial NOT NULL,
    customer_name character varying(500) NOT NULL,
    is_active boolean NOT NULL DEFAULT true,
    customer_address character varying(500) NULL,
    updated_at timestamp(3) without time zone NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_by bigint NULL,
    created_at timestamp(3) without time zone NULL DEFAULT CURRENT_TIMESTAMP(3),
    created_by bigint NULL,
  	effective_start TIMESTAMPTZ NOT NULL,
    effective_end TIMESTAMPTZ,
    is_current BOOLEAN NOT NULL DEFAULT true,
    operation_type CHAR(1) NOT NULL CHECK (operation_type IN ('I','U','D')),
    change_timestamp TIMESTAMPTZ NOT NULL
  );
  
-- products
CREATE TABLE intermediate.products (
  	version_id BIGSERIAL PRIMARY KEY,
    product_id bigserial NOT NULL,
    product_name character varying(500) NOT NULL,
    barcode character varying(26) NOT NULL,
    unity_price numeric NOT NULL,
    is_active boolean NULL,
    updated_at timestamp(3) without time zone NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_by bigint NULL,
    created_at timestamp(3) without time zone NULL DEFAULT CURRENT_TIMESTAMP(3),
    created_by bigint NULL,
  	effective_start TIMESTAMPTZ NOT NULL,
    effective_end TIMESTAMPTZ,
    is_current BOOLEAN NOT NULL DEFAULT true,
    operation_type CHAR(1) NOT NULL CHECK (operation_type IN ('I','U','D')),
    change_timestamp TIMESTAMPTZ NOT NULL
  );





