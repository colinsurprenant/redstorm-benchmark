require 'red_storm'

java_import 'storm.benchmark.GenSpout'

# idea here is to make to bolts as efficient as possible without using
# the DSL syntactic sugar to really benchmark the base JRuby + proxying overhead

class AckBolt < RedStorm::DSL::Bolt
  def execute(tuple)
    collector.ack(tuple)
  end
end

class IdentityBolt < RedStorm::DSL::Bolt
  def execute(tuple)
    # collector.emit_tuple(tuple.getValues)  # with v0.7.0
    collector.emit(tuple.getValues)
    collector.ack(tuple)
  end
end

class BaseRubyTopology < RedStorm::DSL::Topology
  spout GenSpout, [10], :parallelism => 1

  bolt IdentityBolt, :parallelism => 8 do
    output_fields :id, :items
    source GenSpout, :shuffle
  end

  bolt AckBolt, :parallelism => 1 do
    source IdentityBolt, :shuffle
  end

  configure do |env|
    debug false

    num_ackers 0
    num_workers 1
    max_spout_pending 10000

    set "topology.worker.childopts", "-XX:ReservedCodeCacheSize=128m -Djruby.compile.mode=FORCE -Djruby.compile.invokedynamic=true -Djruby.jit.threshold=0 -Djruby.jit.max=-1 -Djruby.ji.objectProxyCache=false"
  end
end
