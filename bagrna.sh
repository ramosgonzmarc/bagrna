#! /usr/bin/bash

if [ $# -eq 0 ]
then
  echo "The number of arguments is: $#"
  echo "Usage: bash bagrna.sh <params_file>"
  echo ""
  echo "params.file: Input file with the parameters"
  exit
fi