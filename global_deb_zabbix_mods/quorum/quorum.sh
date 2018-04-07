#!/bin/bash
nodes_sum=$(pvecm status | grep Expected | awk '{print $ 3}')
nodes_enable=$(pvecm status | grep Total | awk '{print $ 3}')

nodes_disable=$(($nodes_sum - $nodes_enable))
echo $nodes_disable