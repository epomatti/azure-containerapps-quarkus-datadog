docker run --name quarkus-postgres-dev -p 5432:5432 -e POSTGRES_PASSWORD=p4ssw0rd -d postgres



mvn package
docker build -t epomatti/quarkus-documents-jvm .
docker run -i --rm -p 8080:8080 epomatti/quarkus-documents-jvm
