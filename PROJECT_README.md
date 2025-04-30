# ACME Analytical Data Platform
The goal of the this project is developing Analytical Data Platform for ACME Delivery Services.
The platform must be able to:

1. Process large amount of data (millions of records)
2. Allow data consumers to query the historical information along with the current orders’ state
data.
3. Offer a dimensional data model to answer the business queries.
4. Provide access to fresh data to consumers as soon as possible (near real-time).

## Project Rational and architecture
As we are bounded to a restricted time limit to develop the Analytical Platform, we are going to focus on using tools and methods that can proove the concept, but are not intended for production.
The main components of our architecture are:
- Source database: Postgres finance_db.operations
- Analytical database: Postgres finance_db.raw/intermediate/presentation
- CDC tool: Postgres triggers between tables from finance_db.operations to finance_db.raw
- Data Modeling resources: Procedures and Functions created on Postgres finance_db.raw/intermediate/presentation
- API: Dockerized FastAPI deployed on the same network as the Postgres finance_db container

### Source database

### Analytical database
We decided to use the same Postgres instance as the source database (finance_db.operations), in order to focus on the design of the data pipeline and the data model, instead of the storage infrastructure. To foll

On the "Final Thoughts" session at the end of this document, we explore a resilient and robust Data Architecture designed for production ready environments, that could implement the same logic presented here.



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
## 

## Testing the API endpoints
With the application deployed through Docker Compose, we are able to test the API endpoints to return the requested reports:
```bash
# Health check
curl http://localhost:8000/health

# Analytics endpoints
curl "http://localhost:8000/analytics/orders?status=open"
curl "http://localhost:8000/analytics/orders/top?limit=3"
curl "http://localhost:8000/analytics/orders/product"
curl "http://localhost:8000/analytics/orders/customers?status=open&limit=3"
```

## Final thoughts
As mentioned in the project introduction, the architecture we have implemented is focus on showing the concept of integrating a near real-time transactional database, with a Data Analytical Platform in order to provide report resources for the logistic department. With the proof of concept validated by the stakeholders, the next step would invariably move into the discussion of a robust and resilient Data architecture that can offer the resources presented in the PoC, without the limitations.
The diagram below ilustrates a suggested Data Architecture that relies on Cloud Services to achieve it.
![Suggested Data Architecture](./images/acme_suggested_data_architecture.png)
This architecture would have the following components:
1. Source System: In our case it would still be the Postgres we worked on the PoC, deployed on a more reliable way in multiple Availability Zones, probably an AWS RDS, with a read-replica.
2. Streaming Layer: This component would replace the change log tables and audit functions with triggers we created with Postgres. AWS has recently release a new feature for streaming between OLTPs like Postgres and MySQL hosted in RDS straight to Iceberg Tables on S3, through Kinesis Firehose. This could be an easy way to implement the streaming process. But also, we could use other services like AWS DMS or MSK.
3. Storage and Processing Layer: This would be the core layer of our Analytical Platform, as we would use Snowflake storage and processing power. Snowflake is a modern Cloud Data Warehouse, with a focus on data consumers, but a lot of features in terms of integration. Snowflake allows us to access Iceberg Tables as part of its data catalog, meaning we could have access data that's being streamed to S3 right away, in a near real-time fashion, without having to replicate it in Snowflake internal storage. For the other schemas like INTERMEDIATE and PRESENTATION, we could use Snowflake storage
4. Orchestration Layer: We would use dbt as the ETL + Semantic Layer, combined with Airflow as Orchestrator. These two tools are a really powerful combination, enabling pretty much any type of data transformation.
5. Presentation Layer: To enable access to the processed data in Snowflake PRESENTATION schema, we could deploy our Dockerized FastAPI application using AWS ECS, and also use API Gateway as security layer between the requests coming from outside our VPC, and our Application. 

## Project limitations
1. Describe the limitation of using Postgres (OLTP) as warehouse, list other OLAPs that could be used (Snowflake, Redshift, ClickHouse, Databricks)
2. Airflow deployment using Astro CLI -> use a managed service or Kubernetes

## Next steps
1. DRY refactoring: Modularize the SQL code, avoiding the creation of repetitive functions and procedures by replacing hardcode variables as parameters


## References:
- [Astro CLI](https://www.astronomer.io/docs/astro/cli/install-cli/)
- [PostgreSQL Change Data Capture (CDC): The Complete Guide (DataCater)](https://datacater.io/blog/2021-09-02/postgresql-cdc-complete-guide.html)
- [Near Real-Time Database Replication to Apache Iceberg Table on S3 Using Amazon Data Firehose](https://community.aws/content/2rvtWCLKdAE2snztqfUiuMLwR2q/near-real-time-database-replication-to-apache-iceberg-table-on-s3-using-amazon-data-firehose)