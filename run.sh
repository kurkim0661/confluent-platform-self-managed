#!/bin/bash

kubectl apply -f confluent-kafka-zookeeper.yaml
kubectl apply -f confluent-ksqldb.yaml
kubectl apply -f confluent-schemaregistry.yaml
kubectl apply -f confluent-connect.yaml
kubectl apply -f confluent-restapi.yaml
kubectl apply -f confluent-controlcenter.yaml
kubectl apply -f confluent-connector.yaml