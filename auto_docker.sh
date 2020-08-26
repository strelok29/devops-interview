#!/bin/bash



#user settings
echo "what is the container called?"
read tag
echo "how many pods you want to build?"
read replica
echo "what is your docker ID?"
read docker_id
echo "what is the password?"
read -s docker_password
echo "what is the source port?"
read source_port
echo "what do you want to label this container?"
read label
echo
echo "Please wait, image building in process"

#docker build process
echo "$(docker build -t $docker_id/$tag .)"
echo
echo "Docker image has been build"


#docker hub auth and push
echo "$docker_password" | docker login -u "$docker_id" --password-stdin
echo "$(docker push $docker_id/$tag)"

# .yaml template path
config="k8s/deployment-template.yaml"
ingress="k8s/ingress-service-template.yaml"
clusterIP="k8s/cluster-ip-template.yaml"

#change kubernetes .yaml template based on the user settings
sed -e "s/\image_name/$docker_id\\/$tag/g; s/deployment_name/$tag/g; s/container_name/$tag/g; s/replica_number/$replica/g; s/source_port/$source_port/g; s/label_name/$label/g" $config > 'k8s/'$tag'-deployment.yaml'
sed -e "s/source_port/$source_port/g; s/cluster_ip/$tag/g" $ingress > 'k8s/'$tag'-ingress-service.yaml'
sed -e "s/source_port/$source_port/g; s/label_name/$label/g; s/cluster_ip/$tag/g" $clusterIP  > 'k8s/'$tag'-cluster-ip-service.yaml'

#create kubernetes cluster
echo "$(kubectl apply -f k8s/$tag-deployment.yaml)"
echo "$(kubectl apply -f k8s/$tag-cluster-ip-service.yaml)"
read -t 10 -p "Please wait..."
echo "$(kubectl apply -f k8s/$tag-ingress-service.yaml)"