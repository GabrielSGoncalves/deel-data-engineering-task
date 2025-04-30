CREATE
OR REPLACE PROCEDURE intermediate.sync_products_target () LANGUAGE plpgsql AS $procedure$
DECLARE
    _last_id BIGINT;
    _change RECORD;
    _new_row intermediate.product_type;
    _old_row intermediate.product_type;
BEGIN
    SELECT last_processed_change_id INTO _last_id
    FROM intermediate.cdc_sync_state
    WHERE table_name = 'operations.products';

    FOR _change IN
        SELECT change_id, operation, old_data, new_data, changed_at
        FROM raw.products_changelog
        WHERE change_id > _last_id
        ORDER BY change_id
    LOOP
        IF _change.operation = 'I' THEN
            _new_row := jsonb_populate_record(null::intermediate.product_type, _change.new_data);
            
            INSERT INTO intermediate.products (
                product_id, product_name, barcode, unity_price, is_active,
                updated_at, updated_by, created_at, created_by,
                effective_start, operation_type, change_timestamp
            )
            VALUES (
                _new_row.product_id,
                _new_row.product_name,
                _new_row.barcode,
                _new_row.unity_price,
                _new_row.is_active,
                _new_row.updated_at,
                _new_row.updated_by,
                _new_row.created_at,
                _new_row.created_by,
                _change.changed_at,
                'I',
                _change.changed_at
            );

        ELSIF _change.operation = 'U' THEN
            _new_row := jsonb_populate_record(null::intermediate.product_type, _change.new_data);
            
            UPDATE intermediate.products
            SET effective_end = _change.changed_at,
                is_current = false
            WHERE product_id = _new_row.product_id
              AND is_current = true;

            INSERT INTO intermediate.products (
                product_id, product_name, barcode, unity_price, is_active,
                updated_at, updated_by, created_at, created_by,
                effective_start, operation_type, change_timestamp
            )
            VALUES (
                _new_row.product_id,
                _new_row.product_name,
                _new_row.barcode,
                _new_row.unity_price,
                _new_row.is_active,
                _new_row.updated_at,
                _new_row.updated_by,
                _new_row.created_at,
                _new_row.created_by,
                _change.changed_at,
                'U',
                _change.changed_at
            );

        ELSIF _change.operation = 'D' THEN
            _old_row := jsonb_populate_record(null::intermediate.product_type, _change.old_data);
            
            UPDATE intermediate.products
            SET effective_end = _change.changed_at,
                is_current = false,
                operation_type = 'D'
            WHERE product_id = _old_row.product_id
              AND is_current = true;
        END IF;

        _last_id := _change.change_id;
    END LOOP;

    UPDATE intermediate.cdc_sync_state
    SET last_processed_change_id = _last_id
    WHERE table_name = 'operations.products';

    COMMIT;
END;
$procedure$