CREATE TABLE IF NOT EXISTS train_quantified_orc STORED AS ORC AS
SELECT 
  id, features, term_deposit
  FROM train_orc
LATERAL VIEW
  hivemall.quantified_features(
    ${output_row}, age, job, marital, education, default, balance, housing, loan, contact, day, month, duration, campaign, cast(pdays as string), previous, poutcome) t AS features;


CREATE TABLE IF NOT EXISTS classifier3_rf_orc STORED AS ORC AS
SELECT 
  hivemall.train_randomforest_classifier(
    features,
    term_deposit,
	'-trees 50 -seed 71 -attrs Q,C,C,C,C,Q,C,C,C,Q,C,Q,Q,Q,Q,C'
	-- C: categorical_feature, Q: quantitative_feature
  )
FROM
  train_quantified_orc;


CREATE TABLE IF NOT EXISTS test_quantified_orc STORED AS ORC AS
SELECT
  id, 
  array(age, job, marital, education, default, balance, housing, loan, contact, day, month, duration, campaign, pdays, previous, poutcome) as features
FROM (
  SELECT 
    hivemall.quantify(
      output_row, id, age, job, marital, education, default, balance, housing, loan, contact, day, month, duration, campaign, if(pdays==-1,0,pdays), previous, poutcome
    ) AS (id, age, job, marital, education, default, balance, housing, loan, contact, day, month, duration, campaign, pdays, previous, poutcome)
  FROM (
    SELECT * FROM (
      SELECT
        1 AS train_first, false AS output_row, id, age, job, marital, education, default, balance, housing, loan, contact, day, month, duration, campaign, pdays, previous, poutcome
      FROM
        train_orc
      UNION ALL
      SELECT
        2 AS train_first, true AS output_row, id, age, job, marital, education, default, balance, housing, loan, contact, day, month, duration, campaign, pdays, previous, poutcome
      FROM
        test_orc
    ) t0
    ORDER BY train_first, id ASC
  ) t1
) t2;


CREATE TABLE IF NOT EXISTS prediction3_rf_orc STORED AS ORC AS
SELECT
  id,
  hivemall.rf_ensemble(predicted.value, predicted.posteriori, model_weight) AS predicted
FROM (
  SELECT
    id, 
    m.model_weight,
    hivemall.tree_predict(m.model_id, m.model, t.features, "-classification") AS predicted
  FROM
    classifier3_rf_orc m
    LEFT OUTER JOIN
    test_quantified_orc t
) t1
GROUP BY id;


CREATE TABLE IF NOT EXISTS results_rf_orc STORED AS ORC AS
WITH submit AS (
  SELECT 
    t.term_deposit AS actual, 
    p.predicted.label AS predicted,
    t.id AS id
  FROM 
    test_orc t 
    JOIN 
    prediction3_rf_orc p ON (t.id = p.id)
)
SELECT
  id, actual, predicted
FROM
  submit;


CREATE TABLE rf_graphviz_export_orc STORED AS ORC 
tblproperties("orc.compress" = "SNAPPY")
AS
SELECT
  model_id,
  hivemall.tree_export(model, "-type javascript -output_name deposit", 
					   array('age', 'job', 'marital', 'education', 'default', 'balance', 'housing', 'loan', 'contact', 'day', 'month', 'duration', 'campaign', 'pdays', 'previous', 'poutcome'), array('no','yes')) AS js,
  hivemall.tree_export(model, "-type graphviz -output_name deposit", 
					   array('age', 'job', 'marital', 'education', 'default', 'balance', 'housing', 'loan', 'contact', 'day', 'month', 'duration', 'campaign', 'pdays', 'previous', 'poutcome'), array('no','yes')) AS dot
FROM
  classifier3_rf_orc;


SELECT dot FROM rf_graphviz_export_orc;