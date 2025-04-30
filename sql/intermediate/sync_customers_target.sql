CREATE
OR REPLACE PROCEDURE intermediate.sync_customers_target () LANGUAGE plpgsql AS $procedure$
DECLARE
    _last_id BIGINT;
    _change RECORD;
    _new_row intermediate.customer_type;
    _old_row intermediate.customer_type;
BEGIN
    SELECT last_processed_change_id INTO _last_id
    FROM intermediate.cdc_sync_state
    WHERE table_name = 'operations.customers';

    FOR _change IN
        SELECT change_id, operation, old_data, new_data, changed_at
        FROM raw.customers_changelog
        WHERE change_id > _last_id
        ORDER BY change_id
    LOOP
        IF _change.operation = 'I' THEN
            _new_row := jsonb_populate_record(null::intermediate.customer_type, _change.new_data);
            
            INSERT INTO intermediate.customers (
                customer_id, customer_name, is_active, customer_address,
                updated_at, updated_by, created_at, created_by,
                effective_start, operation_type, change_timestamp
            )
            VALUES (
                _new_row.customer_id,
                _new_row.customer_name,
                _new_row.is_active,
                _new_row.customer_address,
                _new_row.updated_at,
                _new_row.updated_by,
                _new_row.created_at,
                _new_row.created_by,
                _change.changed_at,
                'I',
                _change.changed_at
            );

        ELSIF _change.operation = 'U' THEN
            _new_row := jsonb_populate_record(null::intermediate.customer_type, _change.new_data);
            
            UPDATE intermediate.customers
            SET effective_end = _change.changed_at,
                is_current = false
            WHERE customer_id = _new_row.customer_id
              AND is_current = true;

            INSERT INTO intermediate.customers (
                customer_id, customer_name, is_active, customer_address,
                updated_at, updated_by, created_at, created_by,
                effective_start, operation_type, change_timestamp
            )
            VALUES (
                _new_row.customer_id,
                _new_row.customer_name,
                _new_row.is_active,
                _new_row.customer_address,
                _new_row.updated_at,
                _new_row.updated_by,
                _new_row.created_at,
                _new_row.created_by,
                _change.changed_at,
                'U',
                _change.changed_at
            );

        ELSIF _change.operation = 'D' THEN
            _old_row := jsonb_populate_record(null::intermediate.customer_type, _change.old_data);
            
            UPDATE intermediate.customers
            SET effective_end = _change.changed_at,
                is_current = false,
                operation_type = 'D'
            WHERE customer_id = _old_row.customer_id
              AND is_current = true;
        END IF;

        _last_id := _change.change_id;
    END LOOP;

    UPDATE intermediate.cdc_sync_state
    SET last_processed_change_id = _last_id
    WHERE table_name = 'operations.customers';

    COMMIT;
END;
$procedure$