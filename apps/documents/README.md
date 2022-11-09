
docker run --name quarkus-postgres-dev -p 5432:5432 -e POSTGRES_PASSWORD=p4ssw0rd -d postgres

docker build -t epomatti/quarkus-documents-jvm .
docker run -i --rm -p 8080:8080 epomatti/quarkus-documents-jvm


docker network create quarks-dev-bridge
--network quarks-dev-bridge

mvn package

