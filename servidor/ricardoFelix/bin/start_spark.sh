#!/bin/bash
source .bashrc
/usr/local/spark/bin/spark-submit --master local[*] --conf spark.driver.extraClassPath=./ --conf spark.executor.extraClassPath=./ /home/training/ricardoFelix/bin/processamento_spark.py
