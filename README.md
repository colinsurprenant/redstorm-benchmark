# redstorm-benchmark

depends on the RedStorm 0.6.6 branch using JRuby 1.7.4 and Storm 0.9.0-wip16. To use another Storm version, simply supply a custom Storm dependency see the RedStorm README for this. Make sure both the Storm dependency version and the cluster version are the same.

- make sure you are running JRuby 1.7.4
- have Storm 0.9.0-wip16 extracted locally and its bin directory in your path
- have a Storm 0.9.0-wip16 cluster handy
- edit your ~/.storm/storm.yaml to point to your cluster nimbus host
- clone project

### setup

```sh
$ bundle install
$ bundle exec rake setup
```

`rake setup` will:
- install RedStorm
- compile the benchmarking Java classes
- create the topology jar


### run the Java topology

```sh
$ bundle exec redstorm cluster lib/redstorm-benchmark/base_java_topology.rb
```
### run the Ruby topology

```sh
$ bundle exec redstorm cluster lib/redstorm-benchmark/base_ruby_topology.rb
```

