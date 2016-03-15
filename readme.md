# Step by step how to setup this instance:

- Copy docker-compose.example.yml to docker-compose.yml and update it to match your environment configuration
- Make sure volume configuration in docker-compose.yml match your environment configuration (Use code-example to run hello world app and supervisord.example.conf for supervisor configuration)
- Run app-vol instance:

```sh
docker-compose --project-name hello-world up -d app-vol
```

- Build app:

```sh
docker-compose --project-name hello-world build app
```

- Setup google sdk auth:

```sh
docker run --rm -it --volumes-from app-vol helloworld_app gcloud init
```

- Run the app:

```sh
docker-compose --project-name hello-world up -d app
```

**PS: This setup works on March 15, 2016**
*If this is not working when you tried please fix and do a pull request :)*
