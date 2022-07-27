# Specifying python version to install on docker
FROM python:3.9-alpine3.15

# Specifying name/website of the maintainer
LABEL maintainer="divyammakar1511.com"

# Specifying that output should be print directly to console and not buffered
ENV PYHTHONBUFFERED 1

# COPY requirements from local machine to docker
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app

# working directory commands are gonna run from hre
WORKDIR /app
# to access this port and run django command
EXPOSE 8000

# the run command is used to run command on the installed alpine image
# the first line followed by Run is to create a new python Virtual Env [its optional]
# Then 2nd-3rd line is to upgrade and install packages according to our requirements
# then we use command to remove resources to make docker lightWeight
# after that we add a new user with some settings to change from root
# refer to chapter 5 vid 5

#So when we use this dockerfile with any other docker config then its false else with out its true 
ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    # its a shell script code which tells to install dev dependencies  if dev=true 
    # to finish if use fi
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user 

ENV PATH="/py/bin:$PATH"


# this lines changes user from root to the new specified user
USER django-user

