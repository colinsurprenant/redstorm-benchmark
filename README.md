# redstorm-benchmark

Java/JRuby comparative benchmarks of Storm topologies. The idea is to have equivalent topologies in both environments to measure how the JRuby topologies compare to the Java ones.

## dependencies

- [RedStorm](https://github.com/colinsurprenant/redstorm) >= 0.6.6.beta1 (currently the 0.6.6 branch)
- JRuby 1.7.4
- [Storm](https://github.com/nathanmarz/storm/) 0.9.0-wip16.

To use another **Storm version**, supply a [custom Storm dependency](https://github.com/colinsurprenant/redstorm#custom-jar-dependencies-in-your-topology-xml-warning-p). Make sure the Storm version matches the version on the cluster.

To use another **JRuby version**, supply a [custom topology dependency](https://github.com/colinsurprenant/redstorm#custom-jar-dependencies-in-your-topology-xml-warning-p). Make sure your installed JRuby version matches the RedStorm JRuby dependency version

- have Storm extracted locally and its `bin/` directory in your path
- have a Storm cluster handy
- edit your `~/.storm/storm.yaml` to point to your cluster nimbus host
- clone project

## setup

```sh
$ bundle install
$ bundle exec rake setup
```

`rake setup` will:
- install RedStorm
- compile the benchmarking Java classes
- create the topology jar

## base topology benchmark

Both the Java and Ruby base topologies use the same Java emitting spout which spits tuples as fast as possible. Both topologies are built using two bolts without any actual computation. This help measure the JRuby bolt input/output overhead compared to Java.

### run the Java topology

```sh
$ bundle exec redstorm cluster lib/redstorm-benchmark/base_java_topology.rb
```
### run the Ruby topology

```sh
$ bundle exec redstorm cluster lib/redstorm-benchmark/base_ruby_topology.rb
```

