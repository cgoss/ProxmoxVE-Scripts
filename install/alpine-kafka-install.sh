#!/usr/bin/env bash
# Kafka installation script for Alpine Linux using KRaft mode

# Set up logging
exec > >(tee -a "/root/.install-${SESSION_ID:-default}.log") 2>&1
echo "=== Starting Kafka Installation (KRaft Mode) ==="

# Install dependencies
echo "Installing dependencies..."
apk add --no-cache openjdk17-jre bash curl jq
export JAVA_HOME=$(readlink -f /usr/lib/jvm/default-jvm)

# Create directories
mkdir -p /opt/kafka/data /opt/kafka/secrets
chown -R nobody:nogroup /opt/kafka

# Download Kafka
KAFKA_VERSION="3.8.0"  # KRaft mode requires Kafka 3.0.0+
echo "Downloading Kafka $KAFKA_VERSION..."
curl -L "https://downloads.apache.org/kafka/$KAFKA_VERSION/kafka_2.13-$KAFKA_VERSION.tgz" | tar -xz -C /opt/
ln -sf "/opt/kafka_2.13-$KAFKA_VERSION" /opt/kafka

# Generate cluster ID
CLUSTER_ID=$(uuidgen)
echo "Cluster ID: $CLUSTER_ID"

# Configure Kafka for KRaft mode
cat > /opt/kafka/config/kraft/server.properties <<EOF
# KRaft mode configuration
process.roles=broker,controller
node.id=1
controller.quorum.voters=1@${IP}:9093
listeners=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
advertised.listeners=PLAINTEXT://${IP}:9092
inter.broker.listener.name=PLAINTEXT
controller.listener.names=CONTROLLER
log.dirs=/opt/kafka/data
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
group.initial.rebalance.delay.ms=0
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
default.replication.factor=1
min.insync.replicas=1
EOF

# Create systemd service
cat > /etc/systemd/system/kafka.service <<EOF
[Unit]
Description=Apache Kafka (KRaft Mode)
After=network.target

[Service]
Type=simple
User=nobody
Group=nogroup
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/kraft/server.properties --override broker.id=1 --override listeners=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093 --override advertised.listeners=PLAINTEXT://${IP}:9092 --override process.roles=broker,controller --override controller.quorum.voters=1@${IP}:9093
WorkingDirectory=/opt/kafka
Restart=on-failure
Environment=JAVA_HOME=${JAVA_HOME}
Environment=KAFKA_OPTS="-Djava.net.preferIPv4Stack=true"

[Install]
WantedBy=multi-user.target
EOF

# Format the storage directory for KRaft
echo "Formatting Kafka storage for KRaft mode..."
/opt/kafka/bin/kafka-storage.sh format -t "$CLUSTER_ID" -c /opt/kafka/config/kraft/server.properties

# Enable and start service
systemctl daemon-reload
systemctl enable kafka
systemctl start kafka

# Wait for Kafka to be ready
echo "Waiting for Kafka to start..."
for i in {1..30}; do
  if /opt/kafka/bin/kafka-broker-api-versions.sh --bootstrap-server localhost:9092 >/dev/null 2>&1; then
    echo "Kafka is ready!"
    break
  fi
  sleep 2
  echo "Waiting... ($i/30)"
done

# Test installation
echo "Testing Kafka installation..."
/opt/kafka/bin/kafka-broker-api-versions.sh --bootstrap-server localhost:9092

# Create a test topic
echo "Creating test topic..."
/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test --partitions 1 --replication-factor 1

echo "=== Kafka Installation Complete (KRaft Mode) ==="
echo "Cluster ID: $CLUSTER_ID"
echo "Broker listening on: ${IP}:9092"
echo "Controller listening on: ${IP}:9093"