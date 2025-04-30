CREATE TABLE
  raw.order_items_changelog (
    change_id bigserial NOT NULL,
    operation character(1) NOT NULL,
    old_data jsonb NULL,
    new_data jsonb NULL,
    changed_by text NULL DEFAULT CURRENT_USER,
    changed_at timestamp with time zone NULL DEFAULT now()
  );

ALTER TABLE
  raw.order_items_changelog
ADD
  CONSTRAINT order_items_changelog_pkey PRIMARY KEY (change_id)