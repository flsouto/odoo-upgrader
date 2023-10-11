FROM odoo-upgrader
RUN curl https://bootstrap.pypa.io/get-pip.py | python3
RUN curl https://raw.githubusercontent.com/OCA/OpenUpgrade/10.0/requirements.txt > /tmp/requirements.txt
RUN python3 -m pip install setuptools==57
RUN python3 -m pip install -U pip
RUN python3 -m pip install -r /tmp/requirements.txt

