FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install sudo -y
RUN sudo apt-get install software-properties-common -y
RUN sudo add-apt-repository ppa:deadsnakes/ppa -y
RUN sudo apt install python3.7 -y
RUN apt-get install curl -y
RUN sudo apt install python3.7-distutils -y
RUN curl https://bootstrap.pypa.io/get-pip.py | python3.7
RUN apt-get install git -y
RUN python3.7 -m pip install setuptools==57
RUN apt-get install nano -y
RUN git config --global --add safe.directory /openupgrade
RUN sudo apt -y install wget
RUN curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc|sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
RUN sudo apt update
RUN sudo DEBIAN_FRONTEND=noninteractive apt -y install postgresql-12 postgresql-client-12
RUN sudo apt-get install build-essential -y
RUN apt-get install python3.7-dev -y
RUN sudo apt-get install libsasl2-dev libldap2-dev libssl-dev -y
RUN sudo apt-get install libpq-dev -y
COPY ./entrypoint.sh /
RUN chmod 777 ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
