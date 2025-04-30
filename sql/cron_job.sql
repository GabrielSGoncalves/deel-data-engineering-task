-- 1. Ensure pg_cron extension is enabled (requires superuser privileges)
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- 2. Schedule all procedures in a single cron job
SELECT cron.schedule(
    'sync-cdc-targets',
    '*/3 * * * *',  -- Every 3 minutes
    $$
    CALL intermediate.sync_customers_target();
    CALL intermediate.sync_products_target();
    CALL intermediate.sync_orders_target();
    CALL intermediate.sync_order_items_target();
    $$
);

-- 3. Verify the cron job is scheduled
SELECT * FROM cron.job;

-- 4. Monitor execution history
SELECT * FROM cron.job_run_details 
WHERE jobid = 4
ORDER BY start_time DESC LIMIT 5;