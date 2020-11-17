#! /bin/bash

##Help message:
if [ $# -ne 1 ]
then
  echo "The number of arguments is: $#"
  echo "Usage: bash bagrna.sh <params_file>"
  echo ""
  echo "params.file: Input file with the parameters"
  exit
fi

PARAMS=$1

echo "==================="
echo "LOADING PARAMETERS:"
echo "==================="

WD=$(grep working_directory: $PARAMS | awk '{print($2)}')
echo "Working directory = $WD"
EXP=$(grep experiment_name: $PARAMS | awk '{ print($2)}')
echo "Experiment name= $EXP"
NUMSAMPLES=$(grep number_samples: $PARAMS | awk '{ print($2)}')
echo "Number of samples = $NUMSAMPLES"

GENOME=$(grep path_genome: $PARAMS | awk '{print($2)}')
echo "Reference genome = $GENOME"
ANNOTATION=$(grep path_annotation: $PARAMS | awk '{print($2)}')
echo "Annotation= $ANNOTATION"
SAMPLES=()
i=0
while [ $i -lt $NUMSAMPLES ]
do
	j=$(($i + 1))
        SAMPLES[$i]=$(grep path_sample_$j: $PARAMS | awk '{print($2)}')
        ((i++))
done

echo "Samples="
echo "${SAMPLES[@]}"

##Generating work space
echo "==============="

cd $WD
mkdir $EXP
cd $EXP
mkdir genome annotation results samples

cd genome
cp $GENOME genome.fa
cd ../annotation
cp $ANNOTATION annotation.gtf

##Generating reference genome index
extract_splice_sites.py annotation.gtf > annot_splice.ss
extract_exons.py annotation.gtf > annot_exons.exon

cd ../genome
hisat2-build --ss ../annotation/annot_splice.ss --exon ../annotation/annot_exons.exon genome.fa index

cd ../samples
i=1
while [ $i -le $NUMSAMPLES ]
do
	mkdir sample_$i
	cd sample_$i
	j=$(($i - 1))
	cp ${SAMPLES[$j]} sample_$i.fq.gz
	cd ..
	((i++))
done


