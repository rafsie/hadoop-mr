REGISTER 'hdfs://sandbox-hdp.hortonworks.com:8020/user/maria_dev/avgrainfall/charConv.py' USING org.apache.pig.scripting.jython.JythonScriptEngine AS pyudf;
data = LOAD '/user/maria_dev/hive/input/ewp_dsh_zakazenia_po_szczepieniu_202202081142.csv' USING TextLoader AS (col1:bytearray);
-- data = LOAD '/user/maria_dev/hive/input/ewp_dsh_zgony_po_szczep_202202081143.csv' USING TextLoader AS (col1:bytearray);
utfdecoded = FOREACH data GENERATE $0, pyudf.toUTF8(col1);
noquotescols = FOREACH utfdecoded GENERATE REPLACE($1, '\\"', '');
splitted = FOREACH noquotescols GENERATE FLATTEN(STRSPLIT($0,';'));
STORE splitted INTO '/user/maria_dev/hive/output' USING PigStorage(',');