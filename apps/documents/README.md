docker network create quarks-dev-bridge
docker run --name quarkus-postgres-dev --network quarks-dev-bridge -p 5432:5432 -e POSTGRES_PASSWORD=p4ssw0rd -d postgres

docker build -t epomatti/quarkus-documents-jvm .
docker run -i --rm --network quarks-dev-bridge -p 8080:8080 epomatti/quarkus-documents-jvm


mvn package

