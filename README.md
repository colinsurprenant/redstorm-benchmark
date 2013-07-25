# redstorm-benchmark

Java/JRuby comparative benchmarks of Storm topologies. The idea is to have equivalent topologies in both environments to measure how the JRuby topologies compare to the Java ones.

## Dependencies

- [RedStorm](https://github.com/colinsurprenant/redstorm) >= 0.6.6
- JRuby 1.7.4
- [Storm](https://github.com/nathanmarz/storm/) 0.9.0-wip16.

To use another **Storm version**, supply a [custom Storm dependency](https://github.com/colinsurprenant/redstorm#custom-jar-dependencies-in-your-topology-xml-warning-p). Make sure the Storm version matches the version on the cluster.

To use another **JRuby version**, supply a [custom topology dependency](https://github.com/colinsurprenant/redstorm#custom-jar-dependencies-in-your-topology-xml-warning-p). Make sure your installed JRuby version matches the RedStorm JRuby dependency version

- have Storm extracted locally and its `bin/` directory in your path
- have a Storm cluster handy
- edit your `~/.storm/storm.yaml` to point to your cluster nimbus host
- clone project

## Setup

```sh
$ bundle install
$ bundle exec rake setup
```

`rake setup` will:
- install RedStorm
- compile the benchmarking Java classes
- create the topology jar

## Base topology benchmark

The goal with the base topology benchmark is to get an idea of the JRuby + DSL overhead of calling a bolt without any computation, just receiving and emitting tuples.

Both the Java and Ruby base topologies use the same Java emitting spout which spits tuples as fast as possible. Both topologies are built using two bolts without any computation.

### Run the Java topology

```sh
$ bundle exec redstorm cluster lib/redstorm-benchmark/base_java_topology.rb
```
### Run the Ruby topology

```sh
$ bundle exec redstorm cluster lib/redstorm-benchmark/base_ruby_topology.rb
```

## Results

The stats are taken from the last 10 minutes execution window at around the 15th minute of execution.

### Environment

- Single node cluster
- Amazon EC2 m1.large instance (64bits, 4 ECU, 7.6GB)
- Linux 12.10
- RedStorm 0.6.6
- Storm 0.9.0-wip16
- JRuby 1.7.4
- OpenJDK 1.7.0_21

### Topology

- 4 workers
- gen_spout: 2 executors, 2 tasks
- identity_bolt: 8 executors, 8 tasks
- ack_bolt: 2 executors, 2 tasks

### Java

- **54057** tuples/sec emitted
- ack_bolt
  - capacity: 0.093
  - execute latency: 0.007ms
- identity_bolt
  - capacity: 0.092
  - execute latency: 0.018ms

### JRuby

- **29547** tuples/sec emitted
- ack_bolt
  - capacity: 0.624
  - execute latency: 0.082ms
- identity_bolt
  - capacity: 0.858
  - execute latency: 0.445ms
