FROM ubuntu
RUN apt-get update -qq
RUN apt-get install -y python3-pip curl

COPY requirements.txt /work/
WORKDIR /work
RUN pip install -r requirements.txt

COPY . /work/
EXPOSE 5000
CMD [ "flask", "run", "--host=0.0.0.0", "--debug" ]