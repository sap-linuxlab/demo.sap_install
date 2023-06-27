
# Build/Update environemnt
docker build .


# Run for development purposer
docker run --rm -it -h demosetup --name sapdemosetup --env-file ./testenv.docker --entrypoint /bin/bash quay.io/mkoch-redhat/sapdemosetup:latest
