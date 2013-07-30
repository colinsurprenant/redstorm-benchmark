# redstorm-benchmark

Comparative benchmarks of equivalent Java and JRuby Storm topologies.

## Dependencies

- [RedStorm](https://github.com/colinsurprenant/redstorm) >= 0.6.6
- JRuby 1.7.4
- [Storm](https://github.com/nathanmarz/storm/) 0.9.0-wip16.

To use another **Storm version**, supply a [custom Storm dependency](https://github.com/colinsurprenant/redstorm#custom-jar-dependencies-in-your-topology-xml-warning-p). Make sure the Storm version matches the version on the cluster.

To use another **JRuby version**, supply a [custom topology dependency](https://github.com/colinsurprenant/redstorm#custom-jar-dependencies-in-your-topology-xml-warning-p). Make sure your installed JRuby version matches the RedStorm JRuby dependency version

- have a Storm cluster handy
- edit your `~/.storm/storm.yaml` to point to your cluster nimbus host
- clone project

## Setup

```sh
$ bundle install
$ bundle exec rake setup
```

This will:
- install RedStorm
- compile the benchmarking Java classes
- create the topology jar

## Base topology benchmark

The goal with the base topology benchmark is to get an idea of the JRuby overhead of calling bolts without any computation, just receiving and emitting tuples. Obviously this does not indicate the kind of performance to expect from a *real* JRuby topology but gives an indication of the base overhead of using the RedStorm/JRuby layer on Storm. The overall performance of a *real* topology will be affected by many other factors.

To make sure both topologies are stressed the same way, both the Java and Ruby topologies use the **same Java emitting spout** which spits tuples as fast as possible. Both topologies are built using two bolts without any computation.

```sh
$ bundle exec redstorm cluster lib/redstorm-benchmark/base_java_topology.rb
```

```sh
$ bundle exec redstorm cluster lib/redstorm-benchmark/base_ruby_topology.rb
```

### Environment

- Single node cluster
- Amazon EC2 m1.large instance (64bits, 4 ECU, 7.6GB)
- Linux 12.10
- Storm 0.9.0-wip16
- JRuby 1.7.4
- OpenJDK 1.7.0_21

### Topology

On a single node, using a single worker and 8 identity bolts has given the best results (parallelism between 1 to 12 has been tested). No particular JVM/GC tweeking has been made other than providing enough headroom to the worker process with `-Xmx4096m -Xms4096m` and more code cache `-XX:ReservedCodeCacheSize=128m`.

 | executors | tasks
--- | ---: | ---:
gen_spout | 1 | 1
identity_bolt | 8 | 8
ack_bolt | 1 | 1

config | value
--- | ---:
num_workers | 1
num_ackers | 0
max_spout_pending | 10000

### Results

The stats are taken from the last 10 minutes execution window at around the 15th minute of execution.

Note that RedStorm v0.7.0 is still unreleased WIP.

 | Java | JRuby & v0.7.0 | JRuby & v0.6.6
--- | ---: | ---: | ---:
tuples/sec transferred | 156163 | 131843 | 116065
ack_bolt capacity | 0.726 |  0.538 | 0.546
identity_bolt capacity | 0.279 | 0.216 | 0.259
