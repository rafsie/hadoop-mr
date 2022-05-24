-- register UDF
REGISTER 'hdfs://sandbox-hdp.hortonworks.com:8020/user/maria_dev/avgrainfall/charConv.py' USING org.apache.pig.scripting.jython.JythonScriptEngine AS pyudf;

-- load data
data = LOAD '/user/maria_dev/avgrainfall/input/*' USING TextLoader AS (col1:bytearray);

-- use UDF
utfdecoded = FOREACH data GENERATE $0, pyudf.toUTF8(col1);

-- generate columns
columns = FOREACH utfdecoded GENERATE FLATTEN(STRSPLIT($1,','));

-- remove double quotes and assign datatypes
noquotescols = FOREACH columns GENERATE REPLACE($1, '\\"', '') AS (nazwa_stacji:chararray), 
REPLACE($2, '\\"', '') AS (rok:chararray),
REPLACE($3, '\\"', '') AS (miesiac:chararray), (double)$4 AS opad;

-- group by, average and order by
grouped = GROUP noquotescols BY (nazwa_stacji, rok);
avgrainfall = FOREACH grouped GENERATE UniqueID() AS uid, 
FLATTEN(group) AS (nazwa_stacji:chararray, rok:chararray), 
ROUND_TO(AVG(noquotescols.opad),2) AS avgopad;
orderedavgrainfall = ORDER avgrainfall BY nazwa_stacji ASC, rok ASC;

-- store results to HBase table
STORE orderedavgrainfall INTO 'hbase://rainfall' USING org.apache.pig.backend.hadoop.hbase.HBaseStorage('avgannrainfall:nazwa_stacji avgannrainfall:rok avgannrainfall:avgopad');

