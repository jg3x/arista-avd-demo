docker buildx build -f alpine-host/Dockerfile -t avd/alpine:3.19.7 ./alpine-host
docker buildx build -f frr/Dockerfile -t avd/frr:10.2.1 ./frr