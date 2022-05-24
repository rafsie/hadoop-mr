CREATE TABLE IF NOT EXISTS classifier2_add_bias_orc STORED AS ORC AS
SELECT
 feature,
 AVG(weight) AS weight
FROM (
  SELECT 
     hivemall.train_classifier(
       hivemall.add_bias(features), term_deposit,
	   '-loss modified_huber -opt AdaDelta -reg l1 -iters 20'
     ) AS (feature, weight)
  FROM 
     training_orc
 ) t 
GROUP BY feature;


CREATE TABLE IF NOT EXISTS prediction2_add_bias_orc STORED AS ORC AS
WITH exploded AS (
SELECT
  id,
  hivemall.extract_feature(feature) as feature,
  hivemall.extract_weight(feature) as value,
  term_deposit
FROM 
  vectorized_test_orc LATERAL VIEW EXPLODE(hivemall.add_bias(features)) t AS feature
)
SELECT
  t.id, 
  hivemall.sigmoid(SUM(c.weight * t.value)) AS probability,
  t.term_deposit
FROM
  exploded t LEFT OUTER JOIN
  classifier2_add_bias_orc c ON (t.feature = c.feature)
GROUP BY 
  t.id, 
  t.term_deposit;


SELECT id, probability FROM prediction2_add_bias_orc ORDER BY id ASC;