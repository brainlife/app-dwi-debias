#!/bin/bash

set -x
set -e

NCORE=8

dwi=`jq -r '.dwi' config.json`
bvals=`jq -r '.bvals' config.json`
bvecs=`jq -r '.bvecs' config.json`
mask=`jq -r '.mask' config.json`
alg=`jq -r '.type' config.json`
ANTSB=`jq -r '.antsb' config.json`
ANTSC=`jq -r '.antsc' config.json`
ANTSS=`jq -r '.antss' config.json`

mkdir dwi

if [ -f dwi.mif ]; then
	echo "file exists. skipping"
else
	mrconvert -fslgrad $bvecs $bvals $dwi dwi.mif --export_grad_mrtrix dwi.b -stride 1,2,3,4 -force -nthreads $NCORE -quiet
fi

if [ ! -f ${mask} ]; then
	dwi2mask dwi.mif mask.mif -force -nthreads $NCORE && mask="mask.mif"
fi

if [ -f dwi_bias.mif ]; then
	echo "file exists. skipping"
else
	echo "performing ${alg} debiasing"
	if [[ ${alg} == 'ants' ]]; then
		dwibiascorrect -${alg} -ants.b $ANTSB -ants.c $ANTSC -ants.s $ANTSS -mask ${mask} dwi.mif dwi_bias.mif -tempdir ./tmp -force -nthreads $NCORE -quiet
	else
		dwibiascorrect -${alg} -mask ${mask} dwi.mif dwi_bias.mif -tempdir ./tmp -force -nthreads $NCORE -quiet
	fi
fi

if [ -f dwi.nii.gz ]; then
	echo "file exists. debiasing complete"
else
	mrconvert dwi_bias.mif -stride 1,2,3,4 ./dwi/dwi.nii.gz -export_grad_fsl $bvecs $bvals -export_grad_mrtrix dwi.b -json_export dwi.json -force -nthreads $NCORE -quiet
	cp -v ${bvals} ./dwi/
	cp -v ${bvecs} ./dwi/
fi

rm -rf ./tmp/

if [ ! -s ./dwi/dwi.nii.gz ];
then
	echo "output missing"
	exit 1
else
	echo "debiasing complete"
fi
