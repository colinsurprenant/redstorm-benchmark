require 'red_storm'

java_import 'storm.benchmark.GenSpout'

class AckBolt < RedStorm::DSL::Bolt
  on_receive :ack => false, :emit => false do |tuple|
    ack(tuple)
  end
end

class IdentityBolt < RedStorm::DSL::Bolt
  on_receive :ack => false, :emit => false do |tuple|
    collector.emit(tuple.values)
    ack(tuple)
  end
end

class BaseRubyTopology < RedStorm::DSL::Topology
  spout GenSpout, [10], :parallelism => 2

  bolt IdentityBolt, :parallelism => 8 do
    output_fields :id, :items
    source GenSpout, :shuffle
  end

  bolt AckBolt, :parallelism => 2 do
    source IdentityBolt, :shuffle
  end

  configure do |env|
    debug false

    num_ackers 0
    num_workers 4
    max_spout_pending 10000
  end
end
