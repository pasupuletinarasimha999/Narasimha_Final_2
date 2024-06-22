#!/bin/bash
server=$(kubectl config view -o jsonpath='{.clusters[?(@.name=="arn:aws:eks:us-east-1:471112577330:cluster/cluster2")].cluster.server}')
echo "{\"server\": \"$server\"}"