--- practice.log
- ERROR 행에 주석 추가
2024-03-15 09:04:55 ERROR PostService - NullPointerException
앞에 # FIXED 추가

- WARN HikariCP 복사(2줄)

- 날짜 변경(03-15 => 03-16)

- 저장 & 종료

---
1. 설정 파일 수정
# 1. vim application.yml 로 파일 열기
# 2. /dev 로 dev 검색 — n으로 다음 결과 이동
# 3. :%s/dev/prod/g 로 dev → prod 전체 치환
# 4. G 로 파일 마지막 줄 이동 → o 로 새 줄 추가 →
#      com.myapp: INFO 입력 → Esc
# 5. :wq 로 저장 후 종료
# 6. cat application.yml 로 변경 내용 확인
ubuntu@ubuntu:~/13.vim$ ls
application.yml  practice.log  practice.yml
ubuntu@ubuntu:~/13.vim$ vi application.yml 
ubuntu@ubuntu:~/13.vim$ cat application.yml 
server:
  port: 8080
spring:
  datasource:
    url: jdbc:mysql://prod-db:3306/appdb
    username: prod_user
    password: prod_pass123
  redis:
    host: prod-redis.internal
    port: 6379
logging:
  level:
    root: DEBUG
                com.myapp: INFO
ubuntu@ubuntu:~/13.vim$ vi application.yml 
ubuntu@ubuntu:~/13.vim$ cat application.yml 
server:
  port: 8080
spring:
  datasource:
    url: jdbc:mysql://prod-db:3306/appdb
    username: prod_user
    password: prod_pass123
  redis:
    host: prod-redis.internal
    port: 6379
logging:
  level:
    root: DEBUG
    com.myapp: INFO

---
2. 로그 파일 분석 및 편집
# 1. vim app.log 로 열기
# 2. /ERROR 로 첫 번째 ERROR 검색 → n으로 다음 ERROR 이동
# 3. dd 로 현재 ERROR 행 삭제 → u 로 실행 취소
# 4. gg 로 첫 줄 이동 → 3yy 로 3행 복사 → G 로 마지막 줄 이동 → p 로 붙여넣기
# 5. :set number 로 줄 번호 표시
# 6. :q! 로 저장 없이 종료


---
3. 신규 스크립트 작성
# 1. vim deploy.sh 로 새 파일 열기
# 2. i 로 입력 모드 진입 후 아래 내용 입력

#!/bin/bash
APP_NAME="myapp"
VERSION="1.0.0"
LOG_FILE="/home/ubuntu/logs/deploy.log"

echo "[$APP_NAME] 배포 시작: v$VERSION"
echo "배포 완료" >> $LOG_FILE

# 3. Esc → :w 로 저장
# 4. :%s/1.0.0/2.0.0/g 로 버전 변경
# 5. ~/.vimrc 에 set number / set tabstop=4 / syntax on 설정 추가
# 6. :wq 저장 종료 → vim deploy.sh 재오픈하여 줄 번호 표시 확인

