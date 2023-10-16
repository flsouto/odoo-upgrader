VERSION=$1
rm upgrader$VERSION -rf 2>/dev/null
mkdir upgrader$VERSION
cat <<YML > upgrader$VERSION/docker-compose.yml
version: "3"
services:
  main:
    extends:
      file: ../docker-compose.yml
      service: main
    build:
      context: .
    environment:
      - UPGRADER_VERSION=$VERSION
    image: odoo-upgrader$VERSION
YML

if [[ $VERSION -gt 10 ]]; then
    PYTHON_VERSION="3.7"
else
    PYTHON_VERSION="2.7"
fi

cat <<DOC > upgrader$VERSION/Dockerfile
FROM odoo-upgrader
RUN curl https://raw.githubusercontent.com/OCA/OpenUpgrade/$VERSION.0/requirements.txt > /tmp/requirements.txt
RUN python$PYTHON_VERSION -m pip install -r /tmp/requirements.txt
DOC

if [[ $VERSION == 14 ]]; then
cat <<DOC >> upgrader14/Dockerfile
RUN cd / && git clone https://github.com/odoo/odoo.git --depth=1 --branch=14.0
RUN python3.7 -m pip install -r /odoo/requirements.txt
DOC
fi
