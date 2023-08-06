#!/bin/bash

kubectl delete -f confluent-kafka-zookeeper.yaml
kubectl delete -f confluent-ksqldb.yaml
kubectl delete -f confluent-schemaregistry.yaml
kubectl delete -f confluent-connect.yaml
kubectl delete -f confluent-restapi.yaml
kubectl delete -f confluent-controlcenter.yaml
kubectl delete -f confluent-connector.yaml