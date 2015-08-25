## Deploy Thumbor to Amazon EC2 Container Service

  - Sick of combining CarrierWave, Sidekiq and S3 to get image uploads working smoothly?
  - Need a lot of thumbnail sizes for all of your slick mobile and response web apps?
  - Don't want to wait for user uploads to be resized asynchronously to every size?
  
  [Thumbor](https://github.com/thumbor/thumbor) is an on-the-fly image resizing server with a strong community, and it's used all over the place.
  
  With the help of [Thumbor's AWS plugin](https://github.com/thumbor-community/aws) it can read from S3, write resizing meta-data to S3, and write the resized images to S3.
  
  Put a CDN in front of that and you get a performant, scalable, no-hassle image server.
  
### Deployment

Add an Amazon ECS Task Definition with JSON like:
  
```
{
  "family": "Thumbor",
  "containerDefinitions": [
    {
      "name": "Thumbor",
      "image": "papercloud/simple-thumbor-s3:v0.0.2",
      "cpu": "1024",
      "memory": "1024",
      "entryPoint": ["/init"],
      "environment": [],
      "command": [],
      "portMappings": [
        {
          "hostPort": "80",
          "containerPort": "8000",
          "protocol": "tcp"
        }
      ],
      "volumesFrom": [],
      "links": [],
      "mountPoints": [],
      "essential": true,
      "environment": [{
        "name": "SECURITY_KEY",
        "value": "<YOUR THUMBOR SECURITY KEY, see https://github.com/thumbor/thumbor/wiki/Security>"
      },
      {
        "name": "AWS_ACCESS_KEY",
        "value": "<YOUR AWS ACCESS KEY WITH ACCESS TO S3>"
      },
      {
        "name": "AWS_SECRET_KEY",
        "value": "<YOUR SECRET KEY>"
      },
      {
        "name": "RESULT_STORAGE_BUCKET",
        "value": "<YOUR S3 BUCKET>"
      },
      {
        "name": "RESULT_STORAGE_AWS_STORAGE_ROOT_PATH",
        "value": "<A FOLDER IN YOUR S3 BUCKET>"
      },
      {
        "name": "RESULT_STORAGE",
        "value": "tc_aws.result_storages.s3_storage"
      },
      {
        "name": "RESULT_STORAGE_STORES_UNSAFE",
        "value": "True"
      },
      {
        "name": "ALLOW_UNSAFE_URL",
        "value": "False"
      }]
    }
  ],
  "volumes": []
}
```

And that's it. You can then use a [Thumbor client library](https://github.com/thumbor/thumbor/wiki/Libraries) to sign a request, e.g.:

```
require 'ruby-thumbor'
Thumbor::Cascade.new('<YOUR THUMBOR SECURITY KEY>', 'i.imgur.com/MwZwcOY.jpg').width(300).generate
```

then append that to:

`http://<ECS task IP>:80`
