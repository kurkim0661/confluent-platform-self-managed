FROM confluentinc/cp-server-connect:7.4.0
USER root
RUN confluent-hub install --no-prompt debezium/debezium-connector-postgresql:latest
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:latest
USER 1001