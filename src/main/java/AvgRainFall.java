import java.nio.charset.Charset;
import java.io.IOException;
import java.util.Iterator;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapred.*;
import org.apache.log4j.BasicConfigurator;

public class AvgRainFall {

    // Mapper class
    public static class Map extends MapReduceBase implements Mapper
            <LongWritable,            // Input key Type
                    Text,             // Input value Type
                    Text,             // Output key Type
                    DoubleWritable>   // Output value Type
    {

        // Map function
        public void map(LongWritable key, Text value, OutputCollector<Text, DoubleWritable>
                output, Reporter reporter) throws IOException {

            String[] line = new String(value.getBytes(), 0, value.getLength(),
                    Charset.forName("windows-1250")).split(",");
            String station = line[1].replaceAll("\"", "");
            int year = Integer.parseInt(line[2].replaceAll("\"", ""));
            double fall = Double.parseDouble(line[4]);

            output.collect(new Text(station + "\t" + year), new DoubleWritable(fall));
        }
    }

    // Reducer class
    public static class Reduce extends MapReduceBase implements
            Reducer<Text, DoubleWritable, Text, DoubleWritable> {

        // Reduce function
        public void reduce(Text key, Iterator<DoubleWritable> values, OutputCollector<Text, DoubleWritable>
                output, Reporter reporter) throws IOException {

            double avgFall = 0.0;
            double sumOfValues = 0.0;
            int numOfValues = 0;

            while (values.hasNext()) {
                sumOfValues += values.next().get();
                numOfValues++;
                double avgValue = sumOfValues / numOfValues;
                avgFall = (int) (avgValue * 100) / 100.0;
            }
            output.collect(key, new DoubleWritable(avgFall));
        }
    }

    // Main function
    public static void main(String[] args) throws Exception {

        if (args.length != 2) {
            System.err.println("Usage: AvgRainFall <input path> <output path>");
            System.exit(-1);
        }

        BasicConfigurator.configure();
        JobConf conf = new JobConf(AvgRainFall.class);
        conf.setJobName("AvgRainFall");
        conf.setOutputKeyClass(Text.class);
        conf.setOutputValueClass(DoubleWritable.class);
        conf.setMapperClass(Map.class);
        conf.setCombinerClass(Reduce.class);
        conf.setReducerClass(Reduce.class);
        conf.setInputFormat(TextInputFormat.class);
        conf.setOutputFormat(TextOutputFormat.class);
        FileInputFormat.setInputPaths(conf, new Path(args[0]));
        FileOutputFormat.setOutputPath(conf, new Path(args[1]));
        JobClient.runJob(conf);
    }
}