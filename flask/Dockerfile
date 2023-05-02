FROM ubuntu
RUN apt-get update -qq
RUN apt-get install -y python3-pip curl
RUN pip install flask

COPY app.py /work/app.py