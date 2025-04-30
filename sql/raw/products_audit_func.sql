CREATE
OR REPLACE FUNCTION raw.products_audit_func () RETURNS trigger LANGUAGE plpgsql AS $function$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO raw.products_changelog (operation, old_data)
        VALUES ('D', to_jsonb(OLD));
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO raw.products_changelog (operation, old_data, new_data)
        VALUES ('U', to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO raw.products_changelog (operation, new_data)
        VALUES ('I', to_jsonb(NEW));
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$function$