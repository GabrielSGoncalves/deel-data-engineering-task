CREATE
OR REPLACE PROCEDURE intermediate.sync_orders_target () LANGUAGE plpgsql AS $procedure$
DECLARE
    _last_id BIGINT;
    _change RECORD;
    _new_row intermediate.order_type;
    _old_row intermediate.order_type;
BEGIN
    SELECT last_processed_change_id INTO _last_id
    FROM intermediate.cdc_sync_state
    WHERE table_name = 'operations.orders';

    FOR _change IN
        SELECT change_id, operation, old_data, new_data, changed_at
        FROM raw.orders_changelog
        WHERE change_id > _last_id
        ORDER BY change_id
    LOOP
        IF _change.operation = 'I' THEN
            _new_row := jsonb_populate_record(null::intermediate.order_type, _change.new_data);
            
            INSERT INTO intermediate.orders (
                order_id, order_date, delivery_date, customer_id, status,
                updated_at, updated_by, created_at, created_by,
                effective_start, operation_type, change_timestamp
            )
            VALUES (
                _new_row.order_id,
                _new_row.order_date,
                _new_row.delivery_date,
                _new_row.customer_id,
                _new_row.status,
                _new_row.updated_at,
                _new_row.updated_by,
                _new_row.created_at,
                _new_row.created_by,
                _change.changed_at,
                'I',
                _change.changed_at
            );

        ELSIF _change.operation = 'U' THEN
            _new_row := jsonb_populate_record(null::intermediate.order_type, _change.new_data);
            
            -- Expire current version
            UPDATE intermediate.orders
            SET effective_end = _change.changed_at,
                is_current = false
            WHERE order_id = _new_row.order_id
              AND is_current = true;

            -- Insert new version
            INSERT INTO intermediate.orders (
                order_id, order_date, delivery_date, customer_id, status,
                updated_at, updated_by, created_at, created_by,
                effective_start, operation_type, change_timestamp
            )
            VALUES (
                _new_row.order_id,
                _new_row.order_date,
                _new_row.delivery_date,
                _new_row.customer_id,
                _new_row.status,
                _new_row.updated_at,
                _new_row.updated_by,
                _new_row.created_at,
                _new_row.created_by,
                _change.changed_at,
                'U',
                _change.changed_at
            );

        ELSIF _change.operation = 'D' THEN
            _old_row := jsonb_populate_record(null::intermediate.order_type, _change.old_data);
            
            UPDATE intermediate.orders
            SET effective_end = _change.changed_at,
                is_current = false,
                operation_type = 'D'
            WHERE order_id = _old_row.order_id
              AND is_current = true;
        END IF;

        _last_id := _change.change_id;
    END LOOP;

    UPDATE intermediate.cdc_sync_state
    SET last_processed_change_id = _last_id
    WHERE table_name = 'operations.orders';

    COMMIT;
END;
$procedure$