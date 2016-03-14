# Step by step how to setup this instance (This setup works on March 15, 2016):

- Copy docker-compose.example.yml to docker-compose.yml and update it to match your environment configuration
- Make sure volume configuration in docker-compose.yml match your environment configuration
- Run app-vol instance:

```sh
docker-compose up -d app-vol
```

- Pull and setup google/cloud-sdk first:

```sh
docker pull google/cloud-sdk
docker run --rm -it --volumes-from app-vol google/cloud-sdk gcloud init
```
