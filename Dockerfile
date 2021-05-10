# This is Binder-compatible Dockerfile, which will enable:
# - Online execution via https://mybinder.org/ or a similar environment
# - Local execution via Docker
# Ensuring compatibility requires some care in the Dockerfile definition;
# detailed instructions are available at:
# https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html
# while some notes are provided directly in this file as commments

# Specify the base image
# NOTE: Binder requires a tag to be specified
FROM python:3.8

# Define a user whose uid is 1000
# NOTE: this is required for Binder compatibility, to ensure that processes
# are not run as root. The "adduser" command is fine for Debian-based images
# (such as python:3.8) and should be replaced when a different distribution
# is used
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
# NOTE: this is needed again by Binder, to make the notebook contents
# available to all users. We also need to change the ownership of the home
# directory we previously built. The snippet ends with a user switch
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

# Install minimal requirements
# NOTE: these are for Binder compatibility. You can change the jupyter and
# jupyterhub versions, but referring a specific version is highly advised
# to ensure reproducibility
RUN pip install --no-cache-dir notebook==6.2.0
RUN pip install --no-cache-dir jupyterhub

# Specify working directory
WORKDIR ${HOME}

# Use a script as an entrypoint
# ENTRYPOINT ["jupyter"]
# CMD ["notebook", "--port=8888", "--no-browser", \
#      "--ip=0.0.0.0", "--allow-root"]
# ENTRYPOINT ["entrypoint.sh"]
