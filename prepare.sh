touch config.h
git clone https://github.com/apache/avro
git clone https://github.com/edenhill/kafkacat
git clone https://github.com/lloyd/yajl
git clone https://github.com/confluentinc/libserdes
ln librdkafka/src/rdkafka.h librdkafka/rdkafka.h

## KAFKACAT_VERSION=1.6.ZIG zig build
