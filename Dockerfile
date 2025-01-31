ARG DOCKER_BASE_IMAGE_PREFIX
ARG DOCKER_BASE_IMAGE_NAMESPACE=tensorflow
ARG DOCKER_BASE_IMAGE_NAME=tensorflow
ARG DOCKER_BASE_IMAGE_TAG=2.0.0-gpu
FROM ${DOCKER_BASE_IMAGE_PREFIX}${DOCKER_BASE_IMAGE_NAMESPACE}/${DOCKER_BASE_IMAGE_NAME}:${DOCKER_BASE_IMAGE_TAG}

ARG FIX_ALL_GOTCHAS_SCRIPT_LOCATION
ARG ETC_ENVIRONMENT_LOCATION
ARG CLEANUP_SCRIPT_LOCATION

# Depending on the base image used, we might lack wget/curl/etc to fetch ETC_ENVIRONMENT_LOCATION.
ADD $ETC_ENVIRONMENT_LOCATION ./environment.sh
ADD $FIX_ALL_GOTCHAS_SCRIPT_LOCATION .
ADD $CLEANUP_SCRIPT_LOCATION .

RUN set -o allexport \
    && . ./fix_all_gotchas.sh \
    && set +o allexport \
    && apt-get update && apt-get install --assume-yes wget python3-pip \
    && python --version \
    && python3 --version \
    && python -m pip --version \
    && python -m pip install 'tensorflow==2.0.0' \
    && python -c "import tensorflow; print(tensorflow.__version__)" \
    && . ./cleanup.sh

