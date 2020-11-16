#! /usr/bin/bash

if [ $# -eq 0 || $# -gt 1 ]
then
  echo "The number of arguments is: $#"
  echo "Usage: bash bagrna.sh <params_file>"
  echo ""
  echo "params.file: Input file with the parameters"
  exit
fi

PARAMS=$1
EXP=$(grep experiment_name: $PARAMS | awk '{ print($2)}')
echo "Experiment name= $EXP"
