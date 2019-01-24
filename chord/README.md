# Chord

## Team Members:
Sai Tarun Damacharla (4174-0254)
Varun Reddy Regalla (4143-6018)

## Steps for execution:

chord_protocol/chord$ mix escript.build
chord_protocol/chord$ time ./chord 100 10

## What is the largest network we tried with ?
We have tried with 8000 nodes, 100 requests and the average number if hops is 6.45

## What is working ?
1. Implemented chord protocol as suggested in the paper.
2. Worked on developing finger tables for each node in the chord.
3. Each node performes required number of key requestes and finally prints the average number of hops taken for each node to request given amount of keys in the network.
