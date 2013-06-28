require 'red_storm'

java_import 'storm.benchmark.GenSpout'
java_import 'storm.benchmark.AckBolt'
java_import 'storm.benchmark.IdentityBolt'


class BaseJavaTopology < RedStorm::DSL::Topology
  spout GenSpout, [10], :parallelism => 2

  bolt IdentityBolt, :parallelism => 2 do
    source GenSpout, :shuffle
  end

  bolt AckBolt, :parallelism => 2 do
    source IdentityBolt, :shuffle
  end

  configure do |env|
    debug true

    num_ackers 0
    num_workers 2
    max_spout_pending 10000
  end
end
