# hadoop-mr

Few projects implemented on the local Hortonworks 2.6.5 platform, which includes:
- example of calculations made on a [set of meteorological data](https://danepubliczne.imgw.pl/data/dane_pomiarowo_obserwacyjne/dane_meteorologiczne/miesieczne/opad/ "set of meteorological data") using MapReduce (Java) <br/><br/>

- for comparison, the same task (as above) done with Pig Latin, saving the final results to the Apache HBase database <br/><br/>

- process of preparing and cleaning data in Pig for further analysis using Apache Hive and the Hivemall library: <br/><br/>
    * analysis of the [Covid-19 dataset](https://dane.gov.pl/pl/dataset/2582,statystyki-zakazen-i-zgonow-z-powodu-covid-19-z-uw "Covid-19 dataset") cases in Polish voivodeships from 2021-01-01 to 2022-01-31 using the Apache Hive and Hive View builtin data visualization, sample chart below - Number of deaths, dose, immunodeficiency, comorbidities, and median age: <br/><br/>

  ![sql-n.png](img%2Fsql-n.png)<br/><br/>

    * binary classification of a [well-known dataset](https://archive.ics.uci.edu/ml/datasets/Bank+Marketing "well-known dataset"), which is a record of a marketing campaign of one of the Portuguese banks, using the Hivemall library and Apache Zeppelin notebook. Probability distribution in one of the tables and a fragment of the decision tree (Graphviz library) of the Random Forest algorithm below:
	
![prob-id.png](img%2Fprob-id.png)
![dec-tree.jpg](img%2Fdec-tree.jpg)