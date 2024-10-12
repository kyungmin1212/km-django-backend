# alpine 3.19 버전의 리눅스를 구축하는데, 파이썬 버전은 3.11로 설치된 이미지를 불러와줘.
# alpine - 경량화된 리눅스 버전 -> 가볍다 
# -> 빌드가 계속 반복이 되는데, 이미지 자체가 무거우면 빌드속도가 느려지기때문에 가변운거 사용
# 미니콘다 같은거라고 생각
FROM python:3.11-alpine3.19

# 관리자는 나라고 적어주기
LABEL maintainer='kyungmin'

# python 0:1 = False:True
# 컨테이너에 찍히는 로그를 볼 수 있도록 허용합니다.
# 도커 컨테이너에서 어떤일이 벌어지고 있는지 알아야지 디버깅을 할 수 이씃ㅂ니다.
# 실시간으로 볼 수 있기 때문에 컨테이너 관리가 편해집ㄴ디ㅏ.
ENV PYTHONUNBUFFERED=1

# tmp 에 넣는 이유: 컨테이너를 최대한 경량상태로 유지하기 위해
# tmp 폴더는 나중에 빌드가 완료되면 삭제합니다.
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# 장고가 8000번 포트를 사용함 (이 컨테이너에 8000번포트를 지정해줘야한다는 것입니다.)
EXPOSE 8000

# && \ : Enter
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$:PATH"
USER django-user

# Django - Docker - Github Actions(CI/CD)