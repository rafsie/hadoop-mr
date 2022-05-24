-- data = LOAD '/user/maria_dev/hive/input/bank-full-train.csv' USING TextLoader AS (col1:bytearray);
data = LOAD '/user/maria_dev/hive/input/bank-test.csv' USING TextLoader AS (col1:bytearray);
noquotescols = FOREACH data GENERATE REPLACE($0, '\\"', '');
splitted = FOREACH noquotescols GENERATE FLATTEN(STRSPLIT($0,';'));
STORE splitted INTO '/user/maria_dev/hive/output' USING PigStorage(',');