# Memolet

This is a memo application.

### usage

```shell
$ bundle install --without production
$ rails db:migrate
$ rails db:seed
$ rails test
$ rails server
```

`rails db:seed` generates site record and first user as administrator.
You should change name and password of the user as soon as possible. 

### environment

The application works under Heroku and AWS S3.
You need to set environment variables below.

```shell
$ heroku config:set S3_ACCESS_KEY="Access Key"
$ heroku config:set S3_SECRET_KEY="Secret Key"
$ heroku config:set S3_BUCKET="Bucket Name"
$ heroku config:set S3_REGION="Region Name"

```
