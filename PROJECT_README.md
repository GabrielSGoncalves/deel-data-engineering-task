# ACME Analytical Data Platform
The goal of the this project is developing Analytical Data Platform for ACME Delivery Services.
The platform must be able to:

1. Process large amount of data (millions of records)
2. Allow data consumers to query the historical information along with the current orders’ state
data.
3. Offer a dimensional data model to answer the business queries.
4. Provide access to fresh data to consumers as soon as possible (near real-time).

## Setup
### Spining up the source PostgreSQL database
In order to deploy locally the source Postgres, it was needed a small change to avoid permission issues with the mounted volume directory. The PostgreSQL container needs proper permissions to write to the mounted volume directory `/var/lib/postgresql/data`:
```bash
mkdir -p db-data
sudo chown -R 999:999 db-data
```
Next, the PostgreSQL can be deployed using:
```bash
docker compose up
```

## Configuring local Airflow deployment
To orchestrate the data pipeline responsible for moving and transforming data from the source database to the analytical instance we are going to use Airflow.
Airflow is the gold standard in terms of Data Orchestration, with features that enables implementing pipelines that cover almost all required business requirements.
To deploy it locally, we are going to use the Astro CLI, as it facilitates the configuration of the local infrastructure on a testing setting (just like the case of our project).
As the Airflow project is already organized in the current project repository, in order to create a new Airflow instance locally, you only need to execute:
```bash
astro dev start
```
And access the Airflow Webserver at `localhost:8080`.
To stop the Airflow service, just execute the command:
```bash
astro dev stop
```

## Project limitations
1. Describe the limitation of using Postgres (OLTP) as warehouse, list other OLAPs that could be used (Snowflake, Redshift, ClickHouse, Databricks)
2. Airflow deployment using Astro CLI -> use a managed service or Kubernetes

## References:
- [Astro CLI](https://www.astronomer.io/docs/astro/cli/install-cli/)
- [PostgreSQL Change Data Capture (CDC): The Complete Guide (DataCater)](https://datacater.io/blog/2021-09-02/postgresql-cdc-complete-guide.html)