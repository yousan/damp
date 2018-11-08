FROM python:3.6
ENV PYTHONUNBUFFERED 1

# mecabをインストールしておく
RUN apt-get update -y && apt-get install -y \
  mecab  mecab-ipadic-utf8  python-mecab libmecab-dev


RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/static
WORKDIR /usr/src/app
ADD requirements.txt /usr/src/app/
RUN pip install -r requirements.txt
ADD . /usr/src/app/
