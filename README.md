# Quarkus Datadog

Quarkus with Datadog and Container Apps.

## Local development

Enter the app directory:

```sh
cd apps/documents
```

Start Postgres locally:

```
docker run --name quarkus-postgres-dev -p 5432:5432 -e POSTGRES_PASSWORD=p4ssw0rd -d postgres
```

Start Quarkus:

```sh
quarkus dev
```

## Docker Compose

Set the API key and start the containers:

```sh
export DD_API_KEY="0000000000000000000000000000000000000000"

docker-compose build
docker-compose up
```

Test it:

```sh
curl -X POST localhost:8080/documents
curl localhost:8080/documents/1
```
