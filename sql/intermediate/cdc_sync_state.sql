CREATE TABLE
  intermediate.cdc_sync_state (
    table_name text NOT NULL,
    last_processed_change_id bigint NOT NULL DEFAULT 0
  );

ALTER TABLE
  intermediate.cdc_sync_state
ADD
  CONSTRAINT cdc_sync_state_pkey PRIMARY KEY (table_name)