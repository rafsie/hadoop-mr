CREATE TABLE IF NOT EXISTS training_orc STORED AS ORC AS
SELECT
  id,
  hivemall.array_concat(
    hivemall.quantitative_features(
      array("age", "balance", "day", "duration", "campaign", "pdays", "previous"),
      age, balance, day, duration, campaign, pdays, previous
    ),
    hivemall.categorical_features(
      array("job", "marital", "education", "default", "housing", "loan", "contact", "month", "poutcome"), 
			job, marital, education, default, housing, loan, contact, month, poutcome
    )
  ) AS features,
  term_deposit
FROM
  train_orc;


CREATE TABLE IF NOT EXISTS classifier_orc STORED AS ORC AS
SELECT
  hivemall.train_classifier(
    features,
    term_deposit,
    '-loss_function logloss -optimizer SGD -regularization l1'
  ) AS (feature, weight)
FROM
  training_orc;


CREATE TABLE IF NOT EXISTS vectorized_test_orc STORED AS ORC AS
SELECT
  id,
  hivemall.vectorize_features(
    array("age", "job", "marital", "education", "default", "balance", "housing", "loan", 
		  "contact", "day", "month", "duration", "campaign", "pdays", "previous", "poutcome"), 
	age, job, marital, education, default, balance, housing, loan, contact, day, month, 
	duration, campaign, pdays, previous, poutcome
  ) AS features,
  term_deposit
FROM
  test_orc;


CREATE TABLE IF NOT EXISTS prediction_orc STORED AS ORC AS
WITH features_exploded AS
  (SELECT id,
  -- split feature string into its name and value
  -- to join with a model table
 hivemall.extract_feature(fv) AS feature,
 hivemall.extract_weight(fv) AS value,
 term_deposit
   FROM vectorized_test_orc t1 LATERAL VIEW EXPLODE(features) t2 AS fv)
SELECT t1.id,
       hivemall.sigmoid(sum(p1.weight * t1.value)) AS probability,
       t1.term_deposit
FROM features_exploded t1
LEFT OUTER JOIN classifier_orc p1 ON (t1.feature = p1.feature)
GROUP BY t1.id, t1.term_deposit;