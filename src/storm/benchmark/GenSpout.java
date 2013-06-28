// inspired from https://github.com/stormprocessor/storm-benchmark

package storm.benchmark;

import backtype.storm.spout.SpoutOutputCollector;
import backtype.storm.task.TopologyContext;
import backtype.storm.topology.OutputFieldsDeclarer;
import backtype.storm.topology.base.BaseRichSpout;
import backtype.storm.tuple.Fields;
import backtype.storm.tuple.Values;
import backtype.storm.utils.Utils;
import java.util.Map;
import java.util.Random;

public class GenSpout extends BaseRichSpout {
    private static final Character[] CHARS = new Character[] { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'};

    SpoutOutputCollector _collector;
    int _size;
    Random _rand;
    String _id;
    String _val;

    public GenSpout(int size) {
        _size = size;
    }

    @Override
    public void open(Map conf, TopologyContext context, SpoutOutputCollector collector) {
        _collector = collector;
        _rand = new Random();
        _id = randString(5);
        _val = randString(_size);

        // wait 60 seconds before starting to emit.
        // this is to allow the completion of topology initialization before nextTuple starts spinning.
        // on my test one-node cluster running in a VM, this spinning nextTuple starves resources and
        // delays considerably the setup time of the topology with the initialization overhead of JRuby etc.
        Utils.sleep(60000);
    }

    @Override
    public void nextTuple() {
        _collector.emit(new Values(_id, _val));
    }

    private String randString(int size) {
        StringBuffer buf = new StringBuffer();
        for(int i=0; i<size; i++) {
            buf.append(CHARS[_rand.nextInt(CHARS.length)]);
        }
        return buf.toString();
    }

    @Override
    public void declareOutputFields(OutputFieldsDeclarer declarer) {
        declarer.declare(new Fields("id", "item"));
    }
}
