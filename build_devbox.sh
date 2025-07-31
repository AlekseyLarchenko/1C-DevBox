docker build --build-arg ONEC_USERNAME=${ONEC_USERNAME} \
  --build-arg ONEC_PASSWORD=${ONEC_PASSWORD} \
  --build-arg ONEC_VERSION=${ONEC_VERSION} \
  --build-arg DOCKER_REGISTRY_URL=library \
  --build-arg BASE_IMAGE=ubuntu \
  --build-arg BASE_TAG=20.04 \
  -t ${DOCKER_REGISTRY_URL}/devbox:${ONEC_VERSION} \
  -f client/Dockerfile .

docker push $DOCKER_REGISTRY_URL/devbox:$ONEC_VERSION