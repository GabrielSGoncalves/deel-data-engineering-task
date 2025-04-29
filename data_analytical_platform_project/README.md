# ACME Analytical Data Platform
The goal of the this project is developing Analytical Data Platform for ACME Delivery Services.
The platform must be able to:

1. Process large amount of data (millions of records)
2. Allow data consumers to query the historical information along with the current orders’ state
data.
3. Offer a dimensional data model to answer the business queries.
4. Provide access to fresh data to consumers as soon as possible (near real-time).

# Setup
## Spining up the source PostgreSQL database
In order to deploy locally the source Postgres, it was needed a small change to avoid permission issues with the mounted volume directory. The PostgreSQL container needs proper permissions to write to the mounted volume directory `/var/lib/postgresql/data`:
```bash
mkdir -p db-data
sudo chown -R 999:999 db-data
```
Next, the PostgreSQL can be deployed using:
```bash
docker compose up
```

