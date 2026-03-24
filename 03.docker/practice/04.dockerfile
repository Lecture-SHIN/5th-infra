--- Docker file -> build
--- 1. FROM

---
FROM nginx:alpine

---
ubuntu@ubuntu:~/docker$ mkdir 04.dockerfile
ubuntu@ubuntu:~/docker$ cd 04.dockerfile/
ubuntu@ubuntu:~/docker/04.dockerfile$ vi Dockerfile
ubuntu@ubuntu:~/docker/04.dockerfile$ docker images
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
ubuntu@ubuntu:~/docker/04.dockerfile$ docker build -t from-test:1.0 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  2.048kB
Step 1/1 : FROM nginx:alpine
alpine: Pulling from library/nginx
589002ba0eae: Pulling fs layer
59a35f1ae36c9958e4ce0
Status: Downloaded newer image for nginx:alpine
 ---> d0c780774910
Successfully built d0c780774910
Successfully tagged from-test:1.0
ubuntu@ubuntu:~/docker/04.dockerfile$ docker images
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
from-test    1.0       d0c780774910   13 days ago   62.2MB
nginx        alpine    d0c780774910   13 days ago   62.2MB
ubuntu@ubuntu:~/docker/04.dockerfile$ docker images -q
d0c780774910
d0c780774910


--- WORKDIR, COPY
ubuntu@ubuntu:~/docker/04.dockerfile$ vi index.html

<h1>WORKDIR Test</h1>

---
Dockerfile

  1 FROM nginx:alpine
  2 WORKDIR /usr/share/nginx/html
  3 COPY index.html .

---
ubuntu@ubuntu:~/docker/04.dockerfile$ docker build -t workdir-test:1.0 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  3.072kB
Step 1/3 : FROM nginx:alpine
 ---> d0c780774910
Step 2/3 : WORKDIR /usr/share/nginx/html
 ---> Running in 58676ecf3826
 ---> Removed intermediate container 58676ecf3826
 ---> 67ab341766bf
Step 3/3 : COPY index.html .
 ---> b89e956dbf4f
Successfully built b89e956dbf4f
Successfully tagged workdir-test:1.0
ubuntu@ubuntu:~/docker/04.dockerfile$ docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
workdir-test   1.0       b89e956dbf4f   29 seconds ago   62.2MB
from-test      1.0       d0c780774910   13 days ago      62.2MB
nginx          alpine    d0c780774910   13 days ago      62.2MB

--- ADD
ubuntu@ubuntu:~/docker/04.dockerfile$ mkdir -p addtest
ubuntu@ubuntu:~/docker/04.dockerfile$ echo "<p>ADD로 추가된 파일</p>" > addtest/add.html
ubuntu@ubuntu:~/docker/04.dockerfile$ tree
.
├── addtest
│   └── add.html
├── Dockerfile
└── index.html

2 directories, 3 files
ubuntu@ubuntu:~/docker/04.dockerfile$ tar -czf archive.tar.gz addtest/
ubuntu@ubuntu:~/docker/04.dockerfile$ ls
addtest  archive.tar.gz  Dockerfile  index.html

--- Dockerfile
  1 FROM nginx:alpine
  2 WORKDIR /usr/share/nginx/html
  3 COPY index.html .
  4 ADD archive.tar.gz .

---
ubuntu@ubuntu:~/docker/04.dockerfile$ docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
workdir-test   1.0       b89e956dbf4f   23 minutes ago   62.2MB
from-test      1.0       d0c780774910   13 days ago      62.2MB
nginx          alpine    d0c780774910   13 days ago      62.2MB
ubuntu@ubuntu:~/docker/04.dockerfile$ docker build -t add-test:1.0 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  5.632kB
Step 1/4 : FROM nginx:alpine
 ---> d0c780774910
Step 2/4 : WORKDIR /usr/share/nginx/html
 ---> Using cache
 ---> 67ab341766bf
Step 3/4 : COPY index.html .
 ---> Using cache
 ---> b89e956dbf4f
Step 4/4 : ADD archive.tar.gz .
 ---> 7a9d1a815790
Successfully built 7a9d1a815790
Successfully tagged add-test:1.0
ubuntu@ubuntu:~/docker/04.dockerfile$ docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
add-test       1.0       7a9d1a815790   30 seconds ago   62.2MB
workdir-test   1.0       b89e956dbf4f   24 minutes ago   62.2MB
from-test      1.0       d0c780774910   13 days ago      62.2MB
nginx          alpine    d0c780774910   13 days ago      62.2MB

ubuntu@ubuntu:~/docker/04.dockerfile$ docker run --rm add-test:1.0 ls -al
total 20
drwxr-xr-x    1 root     root          4096 Mar 24 08:12 .
drwxr-xr-x    1 root     root          4096 Mar 10 22:32 ..
-rw-r--r--    1 root     root           497 Mar 10 16:28 50x.html
drwxrwxr-x    2 1000     1000          4096 Mar 24 08:05 addtest
-rw-rw-r--    1 root     root            22 Mar 24 07:44 index.html
ubuntu@ubuntu:~/docker/04.dockerfile$ docker run --rm add-test:1.0 tree
.
├── 50x.html
├── addtest
│   └── add.html
└── index.html

1 directories, 3 files
ubuntu@ubuntu:~/docker/04.dockerfile$ docker run --rm add-test:1.0 cat index.html
<h1>WORKDIR Test</h1>



--- ENV, ARG, EXPOSE

--- Dockerfile
  1 FROM nginx:alpine
  2 
  3 ARG ARG_VERSION=1.0.0
  4 ARG ARG_NAME=100
  5 
  6 ENV NGINX_PORT=80
  7 ENV VERSION=${ARG_VERSION}
  8 
  9 WORKDIR /usr/share/nginx/html
 10 COPY index.html .
 11 ADD archive.tar.gz .
 12 
 13 EXPOSE ${NGINX_PORT}

---
ubuntu@ubuntu:~/docker/04.dockerfile$ docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
add-test       1.0       7a9d1a815790   12 minutes ago   62.2MB
workdir-test   1.0       b89e956dbf4f   36 minutes ago   62.2MB
nginx          alpine    d0c780774910   13 days ago      62.2MB
from-test      1.0       d0c780774910   13 days ago      62.2MB
ubuntu@ubuntu:~/docker/04.dockerfile$ docker build -t env-test:1.0 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  5.632kB
Successfully built 2194d6144fe6
Successfully tagged env-test:1.0
ubuntu@ubuntu:~/docker/04.dockerfile$ docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
env-test       1.0       2194d6144fe6   29 seconds ago   62.2MB
add-test       1.0       7a9d1a815790   13 minutes ago   62.2MB
workdir-test   1.0       b89e956dbf4f   37 minutes ago   62.2MB
from-test      1.0       d0c780774910   13 days ago      62.2MB
nginx          alpine    d0c780774910   13 days ago      62.2MB
ubuntu@ubuntu:~/docker/04.dockerfile$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu@ubuntu:~/docker/04.dockerfile$ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

--- 
ubuntu@ubuntu:~/docker/04.dockerfile$ docker run --rm env-test:1.0 env | grep -E "NGINX_PORT|VERSION"
ACME_VERSION=0.3.1
VERSION=1.0.0
NGINX_VERSION=1.29.6
NJS_VERSION=0.9.6
NGINX_PORT=80


---
ubuntu@ubuntu:~/docker/04.dockerfile$ docker build --build-arg ARG_VERSION=2.0.0 -t env-test:2.0 .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  5.632kB
Successfully tagged env-test:2.0

ubuntu@ubuntu:~/docker/04.dockerfile$ docker run --rm env-test:2.0 env | grep -E "NGINX_PORT|VERSION"
ACME_VERSION=0.3.1
VERSION=2.0.0
NGINX_VERSION=1.29.6
NJS_VERSION=0.9.6
NGINX_PORT=80

ubuntu@ubuntu:~/docker/04.dockerfile$ docker image inspect env-test:2.0 | grep "80/tcp"
                "80/tcp": {}