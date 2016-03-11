# docker-elasticsearch
Docker image for elasticsearch

## Build

    git clone https://github.com/skylost/docker-elasticsearch.git
    docker build -t skylost/elasticsearch .

## Run

    docker run -d -p 9200:9200 -p 9300:9300 -name elastic skylost/elasticsearch 

## Usage
