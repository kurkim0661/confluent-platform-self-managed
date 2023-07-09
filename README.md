# confluent-platform-self-managed
# Deploy CFK using the download bundle
Download the CFK bundle using the following command, and unpack the downloaded bundle:

```curl -O https://confluent-for-kubernetes.s3-us-west-1.amazonaws.com/confluent-for-kubernetes-2.6.0.tar.gz```

From the helm sub-directory of where you downloaded the CFK bundle, install CFK:

`helm upgrade --install confluent-operator \
  ./confluent-for-kubernetes \
  --namespace confluent --create-namespace`

Set your default context namespace confluent
`kubectl config set-context --current --namespace confluent`


# Use Confluent Control Center to monitor the Confluent Platform, and see the created topic and data.

Set up port forwarding to Control Center web UI from your local machine:

kubectl port-forward controlcenter-0 9021:9021 -n confluent
Browse to Control Center:

http://localhost:9021

Check that the elastic-0 topic was created and that messages are being produced to the topic.

# kafka, zookeeper 의 mount 과정에서 문제가 있음... 

volume mount 문제를 해결하기 위해서 default addon을 제거하고 CSI Driver 를 설치
Enable addons
Enable volumesnapshots and csi-hostpath-driver addons:

```
minikube addons enable volumesnapshots
minikube addons enable csi-hostpath-driver
```
Optionally you could use it as a default storage class for the dynamic volume claims:

```
minikube addons disable storage-provisioner
minikube addons disable default-storageclass
```

```
kubectl patch storageclass csi-hostpath-sc-customed -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
```

그리고 volumeBindingMode를 WaitForFirstConsumer로 변경해서 같은 노드에 형성되어 연결될 수 있도록 설치.

```
kubectl apply -f storageclass.yaml

kubectl delete sc csi-hostpath-sc
```

default를 새로만든 storageclass로 설정하기 위해서 기존 storageclass는 삭제한다.
변경하고 나니 mount되는 volume에 대한 권한 문제가 발생... 이 부분은 해결이 필요.

# minikube docker registry에 image build하기

`minikube docker-env` 명령어를 치면 아래와 같이 minikube의 docker-env 정보가 나온다

```
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://127.0.0.1:64492"
export DOCKER_CERT_PATH="/Users/jihwankim/.minikube/certs"
export MINIKUBE_ACTIVE_DOCKERD="minikube"

# To point your shell to minikube's docker-daemon, run:
# eval $(minikube -p minikube docker-env)
```

아래 eval 명령어를 실행해서 docker engine을 잠시 minikube 의 docker engine으로 변경하고 docker 작업을 진행하면 된다!

단 세션이 끊기면 새로 해줘야함 환경변수가 변경되기 때문!