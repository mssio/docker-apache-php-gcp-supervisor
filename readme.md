# Project Information

This project contains:

 - based on php:5.6.19-apache with this module installed:
   - mcrypt
   - gd
 - supervisor installed
 - composer installed & configured
 - Google Cloud Library installed based on it's Dockerfile (https://github.com/GoogleCloudPlatform/cloud-sdk-docker/blob/master/Dockerfile) on March 15 2016.
 - entrypoint will do composer install in /var/www/html and then start the supervisor (make sure supervisor configuration is correct to prevent any errors).



# Step by step how to setup this instance:

- Copy docker-compose.example.yml to docker-compose.yml and update it to match your environment configuration
- Make sure volume configuration in docker-compose.yml match your environment configuration (Use code-example to run hello world app and supervisord.example.conf for supervisor configuration)
- Setup cron.conf configuration inside .cron-config volume
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
