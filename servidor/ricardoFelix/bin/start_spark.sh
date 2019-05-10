#!/bin/bash
source .bashrc
#export PYSPARK_PYTHON=/usr/bin/python
/usr/local/spark/bin/spark-submit --master local[*] --conf spark.driver.extraClassPath=./ --conf spark.executor.extraClassPath=./ /home/training/ricardoFelix/bin/processamentospark.py
