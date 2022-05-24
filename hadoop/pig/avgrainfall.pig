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
avgrainfall = FOREACH grouped GENERATE FLATTEN(group), ROUND_TO(AVG(noquotescols.opad),2);
orderedavgrainfall = ORDER avgrainfall BY $0 ASC, $1 ASC;

-- display results
DUMP orderedavgrainfall;