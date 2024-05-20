#!/bin/bash
echo $1
echo $2
if [ ! -n "$3" ] ;then
  tag_version=latest
else
  tag_version=$3
fi
docker_tag=registry.paas/bcop/$(echo $1| tr '[A-Z]' '[a-z]'):$tag_version
echo ${docker_tag}
rm -rf $1
if [ ! -d "${1}" ]; then
tar -xvf ${1}.tar
fi
if [ ! -e ${1}.Dockerfile ];then
    sed -e 's/WEB-PROGRAM/'$1'/g' -e 's/TOP/'$2'/g' patch-dockerfile > ${1}.Dockerfile
fi
docker build -t ${docker_tag} . -f ${1}.Dockerfile
docker push $docker_tag
kubectl apply -f test-ui.yaml