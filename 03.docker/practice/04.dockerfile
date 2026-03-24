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
