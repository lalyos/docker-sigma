FROM ubuntu
RUN apt-get update -qq
RUN apt-get install -y python3-pip curl
RUN pip install flask

COPY . /work/
WORKDIR /work
EXPOSE 5000
CMD [ "flask", "run", "--host=0.0.0.0" ]