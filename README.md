# Install Postgresql using helm

```bash
helm upgrade --install postgresql ./postgresql
```

```bash
kubectl port-forward svc/postgresql 5432:5432 
```

Postgresql 를 host 에 forwarding 시키고 해당 postgresql database 에 테스트에 사용할 table을 만들어준다.

# minikube cluster 구성

Test 환경이기 때문에 사양은 local 환경에 맞춰서 구성하면 된다.

```bash
minikube start --nodes 3 --memory 8GB --cpus 3 -p confluent-demo --insecure-registry='0.0.0.0/0'
```

affinity 를 활용하기 위해서 node 는 4개로 구성을 하고 docker image 를 활용하기 위해서 insecure-registry 를 적용하여 network 연결 문제를 미리 해결.

multi node 구성을 위해 custom csi driver 설치

## kubevirt.io 를 설치
kubevirt.io/hostpath-provisioner 를 사용한다. 

```bash
kubectl delete sc standard
kubectl apply -f storageclass.yaml
```


# Deploy CFK using the download bundle
Download the CFK bundle using the following command, and unpack the downloaded bundle:

```curl -O https://confluent-for-kubernetes.s3-us-west-1.amazonaws.com/confluent-for-kubernetes-2.6.0.tar.gz```

From the helm sub-directory of where you downloaded the CFK bundle, install CFK:

```bash
helm upgrade --install confluent-operator ./confluent-for-kubernetes --namespace confluent --create-namespace
```


Set your default context namespace confluent
`kubectl config set-context --current --namespace confluent`

# Node labeling 을 통한 affinity
```bash
kubectl label nodes confluent-demo-m02 foo.service=broker
kubectl label nodes confluent-demo-m03 foo.service=broker
```

# minikube docker registry에 image build하기
registry add on 설치
```bash
minikube addons enable registry -p confluent-demo
```

## redirect docker vm

```bash
docker run --rm -it -d --network=host alpine ash -c "apk add socat && socat TCP-LISTEN:5000,reuseaddr,fork TCP:$(minikube ip -p confluent-demo):5000"
```
## build docker image

```bash
docker build --tag cp-server-connect-psql:latest .
docker tag cp-server-connect-psql:latest localhost:5000/cp-server-connect-psql
docker push localhost:5000/cp-server-connect-psql
```

## Push docker image

```bash
docker push localhost:5000/cp-server-connect-psql
```

# confluent-platform 설치하기

```bash
./run.sh
```


# Use Confluent Control Center to monitor the Confluent Platform, and see the created topic and data.

Set up port forwarding to Control Center web UI from your local machine:

kubectl port-forward controlcenter-0 9021:9021 -n confluent
Browse to Control Center:

http://localhost:9021

Check that the elastic-0 topic was created and that messages are being produced to the topic.