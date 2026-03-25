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


--- CMD, ENTRYPOINT
--- CMD
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
 14 CMD ["nginx", "-g", "daemon off;"]


 ubuntu@ubuntu:~/docker/04.dockerfile$ docker build -t cmd-test .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  5.632kB
Step 10/10 : CMD ["nginx", "-g", "daemon off;"]
 ---> Running in 321f9b83ee56
 ---> Removed intermediate container 321f9b83ee56
 ---> d4226d14d095
Successfully built d4226d14d095
Successfully tagged cmd-test:latest
ubuntu@ubuntu:~/docker/04.dockerfile$ docker images
REPOSITORY     TAG       IMAGE ID       CREATED          SIZE
cmd-test       latest    d4226d14d095   18 seconds ago   62.2MB
env-test       2.0       886c36085194   16 hours ago     62.2MB
env-test       1.0       2194d6144fe6   16 hours ago     62.2MB
add-test       1.0       7a9d1a815790   16 hours ago     62.2MB
workdir-test   1.0       b89e956dbf4f   17 hours ago     62.2MB
from-test      1.0       d0c780774910   2 weeks ago      62.2MB
nginx          alpine    d0c780774910   2 weeks ago      62.2MB

ubuntu@ubuntu:~/docker/04.dockerfile$ docker run --rm cmd-test
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration

ubuntu@ubuntu:~/docker/04.dockerfile$ docker run --rm cmd-test echo hello
hello


--- ENTRYPOINT
ubuntu@ubuntu:~/docker/04.dockerfile$ docker build -t ep-test .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  5.632kB
Step 10/10 : ENTRYPOINT ["nginx"]
 ---> Running in d4446cff70fe
 ---> Removed intermediate container d4446cff70fe
 ---> 158a89bb31ac
Successfully built 158a89bb31ac
Successfully tagged ep-test:latest

ubuntu@ubuntu:~/docker/04.dockerfile$ docker run --rm ep-test -g "daemon off;"
2026/03/25 00:30:47 [notice] 1#1: using the "epoll" event method
2026/03/25 00:30:47 [notice] 1#1: nginx/1.29.6
2026/03/25 00:30:47 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
2026/03/25 00:30:47 [notice] 1#1: OS: Linux 6.8.0-106-generic
2026/03/25 00:30:47 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2026/03/25 00:30:47 [notice] 1#1: start worker processes
2026/03/25 00:30:47 [notice] 1#1: start worker process 7

--- 실무 : CMD + ENTRYPOINT 
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
 14 ENTRYPOINT ["nginx"]
 15 CMD ["-g", "daemon off;"]

ubuntu@ubuntu:~/docker/04.dockerfile$ docker build -t cmd-ep-test .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  5.632kB
Step 10/11 : ENTRYPOINT ["nginx"]
 ---> Using cache
 ---> 158a89bb31ac
Step 11/11 : CMD ["-g", "daemon off;"]
 ---> Running in 73e91b988e5c
 ---> Removed intermediate container 73e91b988e5c
 ---> d574d7172dd7
Successfully built d574d7172dd7
Successfully tagged cmd-ep-test:latest

ubuntu@ubuntu:~/docker/04.dockerfile$ docker run --rm cmd-ep-test 
2026/03/25 00:35:49 [notice] 1#1: using the "epoll" event method
2026/03/25 00:35:49 [notice] 1#1: nginx/1.29.6
2026/03/25 00:35:49 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
2026/03/25 00:35:49 [notice] 1#1: OS: Linux 6.8.0-106-generic
2026/03/25 00:35:49 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2026/03/25 00:35:49 [notice] 1#1: start worker processes
2026/03/25 00:35:49 [notice] 1#1: start worker process 7

--- USER

--- 백업 후 진행
ubuntu@ubuntu:~/docker/04.dockerfile$ cp Dockerfile Dockerfile.bak
ubuntu@ubuntu:~/docker/04.dockerfile$ ls
addtest  archive.tar.gz  Dockerfile  Dockerfile.bak  index.html

--- Dockerfile
FROM nginx:alpine

# 전용 사용자 생성
# ubuntu : groupadd --system
RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

# nginx가 필요한 디렉토리 권한 미리 설정
RUN mkdir -p /var/cache/nginx/client_temp \
             /var/cache/nginx/proxy_temp \
             /var/cache/nginx/fastcgi_temp \
             /var/cache/nginx/uwsgi_temp \
             /var/cache/nginx/scgi_temp \
    && chown -R appuser:appgroup /var/cache/nginx \
    && chown -R appuser:appgroup /var/log/nginx \
    && chown -R appuser:appgroup /etc/nginx/conf.d \
    && touch /var/run/nginx.pid \
    && chown appuser:appgroup /var/run/nginx.pid

# nginx.conf에서 user 지시어 제거 (비root 실행 시 불필요)
RUN sed -i '/^user/d' /etc/nginx/nginx.conf

# 파일 소유권 변경
# COPY index.html /usr/share/nginx/html/
# RUN chwon appuser:appgroup /usr/share/nginx/html/index.html
COPY --chown=appuser:appgroup index.html /usr/share/nginx/html/

USER appuser

EXPOSE 80

--- 결과 확인

ubuntu@ubuntu:~/docker/04.dockerfile$ docker images | grep secure-
secure-test   latest    4d2d89349173   About an hour ago   62.2MB

---
ubuntu@ubuntu:~/docker/04.dockerfile$ docker inspect secure-test:latest | grep -i user
            "User": "appuser",

--- 실행 확인
ubuntu@ubuntu:~/docker/04.dockerfile$ docker run -d --name mynginx s
ecure-test

ubuntu@ubuntu:~/docker/04.dockerfile$ docker logs mynginx 
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration

ubuntu@ubuntu:~/docker/04.dockerfile$ docker exec mynginx whoami
appuser

--- 멀티 플랫폼 빌더
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx build --platform=linux/amd64,linux/arm64 -t dockerlecture/infra-basic:latest --push .
[+] Building 0.0s (0/0)                                           docker:default
ERROR: Multi-platform build is not supported for the docker driver.
Switch to a different driver, or turn on the containerd image store, and try again.
Learn more at https://docs.docker.com/go/build-multi-platform/
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx ls
NAME/NODE     DRIVER/ENDPOINT   STATUS    BUILDKIT   PLATFORMS
default*      docker                                 
 \_ default    \_ default       running   v0.22.0    linux/amd64 (+3), linux/386
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx create --name multibuilder --use
multibuilder
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx ls
NAME/NODE           DRIVER/ENDPOINT                   STATUS     BUILDKIT   PLATFORMS
multibuilder*       docker-container                                        
 \_ multibuilder0    \_ unix:///var/run/docker.sock   inactive              
default             docker                                                  
 \_ default          \_ default                       running    v0.22.0    linux/amd64 (+3), linux/386

ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx inspect --builder multibuilder --bootstrap
[+] Building 24.1s (1/1) FINISHED                                                                                                                                            
 => [internal] booting buildkit                                                                                                                                        24.0s
 => => pulling image moby/buildkit:buildx-stable-1                                                                                                                     22.0s
 => => creating container buildx_buildkit_multibuilder0                                                                                                                 2.0s
Name:          multibuilder
Driver:        docker-container
Last Activity: 2026-03-25 02:21:24 +0000 UTC

Nodes:
Name:     multibuilder0
Endpoint: unix:///var/run/docker.sock
Error:    Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.48/containers/buildx_buildkit_multibuilder0/json": context deadline exceeded
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx ls
NAME/NODE           DRIVER/ENDPOINT                   STATUS    BUILDKIT   PLATFORMS
multibuilder*       docker-container                                       
 \_ multibuilder0    \_ unix:///var/run/docker.sock   running   v0.28.0    linux/amd64 (+3), linux/386

ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx build --platform=linux/amd64,linux/arm64 -t dockerlecture/infra-basic:latest --push .

ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx imagetools inspect dockerlecture/infra-basic:latest

ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx ls
NAME/NODE           DRIVER/ENDPOINT                   STATUS    BUILDKIT   PLATFORMS
multibuilder*       docker-container                                       
 \_ multibuilder0    \_ unix:///var/run/docker.sock   running   v0.28.0    linux/amd64 (+3), linux/386
default             docker                                                 
 \_ default          \_ default                       running   v0.22.0    linux/amd64 (+3), linux/386
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx use default
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx ls
NAME/NODE           DRIVER/ENDPOINT                   STATUS    BUILDKIT   PLATFORMS
multibuilder        docker-container                                       
 \_ multibuilder0    \_ unix:///var/run/docker.sock   running   v0.28.0    linux/amd64 (+3), linux/386
default*            docker                                                 
 \_ default          \_ default                       running   v0.22.0    linux/amd64 (+3), linux/386
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx stop multibuilder
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx ls
NAME/NODE           DRIVER/ENDPOINT                   STATUS    BUILDKIT   PLATFORMS
multibuilder        docker-container                                       
 \_ multibuilder0    \_ unix:///var/run/docker.sock   stopped              
default*            docker                                                 
 \_ default          \_ default                       running   v0.22.0    linux/amd64 (+3), linux/386
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx rm  multibuilder
multibuilder removed
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx ls
NAME/NODE     DRIVER/ENDPOINT   STATUS    BUILDKIT   PLATFORMS
default*      docker                                 
 \_ default    \_ default       running   v0.22.0    linux/amd64 (+3), linux/386
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx du
Reclaimable:    0B
Total:          0B
ubuntu@ubuntu:~/docker/04.dockerfile$ docker buildx prune

---
2. .dockerignore 효과 확인
# 현재 위치: /home/ubuntu/docker/04.dockerfile/nginx

# 1. .dockerignore 없이 빌드 → 빌드 컨텍스트 전송 크기 확인
docker build -t nginx-test:1.0 .
# "Sending build context to Docker daemon" 크기 확인

# 2. .dockerignore 생성
echo "fake_target/" > .dockerignore

# 3. .dockerignore 적용 후 재빌드 → 컨텍스트 크기 비교
docker build -t nginx-test:2.0 .

# 4. 두 이미지 크기 비교 (docker images)
# → 빌드 컨텍스트가 달라도 최종 이미지 크기는 동일 (COPY한 파일만 포함)
# → 빌드 속도 차이 확인

# 5. docker rm -f 및 이미지 정리
docker rmi nginx-test:1.0 nginx-test:2.0


---
  ubuntu@ubuntu:~/docker/04.dockerfile/nginx$ tree
.
├── Dockerfile
├── fake_target
│   └── dummy.jar
└── index.html

2 directories, 3 files

ubuntu@ubuntu:~/docker/04.dockerfile/nginx$ docker build -t nginx-test:1.0 .
[+] Building 2.9s (8/8) FINISHED                     docker:default
 => [internal] load build definition from Dockerfile           0.0s
 => => transferring dockerfile: 74B                            0.0s
 => [internal] load metadata for docker.io/library/nginx:alpi  1.4s
 => [auth] library/nginx:pull token for registry-1.docker.io   0.0s
 => [internal] load .dockerignore                              0.1s
 => => transferring context: 2B                                0.0s
 => [internal] load build context                              0.4s
 => => transferring context: 10.49MB                           0.4s
 => CACHED [1/2] FROM docker.io/library/nginx:alpine@sha256:e  0.2s
 => => resolve docker.io/library/nginx:alpine@sha256:e7257f1e  0.2s
 => [2/2] COPY . .                                             0.3s
 => exporting to image                                         0.2s
 => => exporting layers                                        0.1s
 => => writing image sha256:b62fe328f95cd3ab79cc0db8c92cd0a61  0.0s
 => => naming to docker.io/library/nginx-test:1.0              0.0s


ubuntu@ubuntu:~/docker/04.dockerfile/nginx$ ll
total 20
drwxrwxr-x 3 ubuntu ubuntu 4096 Mar 25 17:26 ./
drwxrwxr-x 7 ubuntu ubuntu 4096 Mar 25 17:16 ../
-rw-rw-r-- 1 ubuntu ubuntu   37 Mar 25 13:24 Dockerfile
-rw-rw-r-- 1 ubuntu ubuntu    0 Mar 25 13:22 .env
drwxrwxr-x 2 ubuntu ubuntu 4096 Mar 25 13:03 fake_target/
-rw-rw-r-- 1 ubuntu ubuntu  151 Mar 25 13:03 index.html
ubuntu@ubuntu:~/docker/04.dockerfile/nginx$ vi Dockerfile 
ubuntu@ubuntu:~/docker/04.dockerfile/nginx$ echo "fake_target/" > .dockerignore
ubuntu@ubuntu:~/docker/04.dockerfile/nginx$ echo ".env" >> .dockerignore
ubuntu@ubuntu:~/docker/04.dockerfile/nginx$ docker build -t nginx-test:2.0 .
[+] Building 2.0s (7/7) FINISHED                                 docker:default
 => [internal] load build definition from Dockerfile                       0.1s
 => => transferring dockerfile: 74B                                        0.0s
 => [internal] load metadata for docker.io/library/nginx:alpine            0.8s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 58B                                           0.0s
 => [internal] load build context                                          0.1s
 => => transferring context: 117B                                          0.0s
 => CACHED [1/2] FROM docker.io/library/nginx:alpine@sha256:e7257f1ef28ba  0.1s
 => => resolve docker.io/library/nginx:alpine@sha256:e7257f1ef28ba17cf7c2  0.1s
 => [2/2] COPY . .                                                         0.3s
 => exporting to image                                                     0.3s
 => => exporting layers                                                    0.1s
 => => writing image sha256:2005d72aef3ffaf5cd075cdf5324ef8f8bb1772561daf  0.0s
 => => naming to docker.io/library/nginx-test:2.0    
