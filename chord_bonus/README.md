#Chord

Team Members:
Sai Tarun Damacharla (4174-0254)
Varun Reddy Regalla (4143-6018)

##Steps for execution:

chord_protocol/chord_bonus$ mix escript.build
chord_protocol/chord_bonus$ time ./chord 50 4

## What is the largest network we tried with ?
We have tried with 8000 nodes, 100 requests and the average number if hops is 6.41

## What is working ?
  1.  Implemented chord protocol as suggested in the paper
  2. Worked on developing finger tables for each node in the chord
  3. Each node performes required number of key requestes and finally prints the average number of hops taken for each node to request given amount of keys in the network
  4. Later we calculated the average number of hops upon node failure, by making a node to fail and updateing the rest of the node's finger tables with failed node information.

## How we tested and findings ?
1. We have calculated the average number of hops before node failure and after the node failure
2. We found that the system is stable while satisfying the required factors

Findings:

For 50 nodes and 2 requests:

Average number of hops before node failure: 2.87
<PID> exited
Average number of hops after node failure: 2.826

For 100 nodes and 3 requests:

Average number of hops before node failure: 3.26
<PID> exited
Average number of hops after node failure: 3.25
