# centos6 + apache + php

image作成

```
$ docker build -t oppara/centos6-apache-php .

or

$ docker build -t oppara/centos6-apache-php:TAG .
```

確認

```
$ docker-compose up
$ open http://127.0.0.1:8000
```
