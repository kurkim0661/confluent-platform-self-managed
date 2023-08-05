#!/bin/bash

kubectl apply -f confluent-platform.yaml
kubectl apply -f confluent-ksqldb.yaml
kubectl apply -f confluent-schemaregistry.yaml
kubectl apply -f confluent-restapi.yaml
kubectl apply -f confluent-connect.yaml