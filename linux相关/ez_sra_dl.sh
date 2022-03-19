#!/bin/evn bash

########################################
# The easy way to download batch       #
# sra data from NCBI using sratoolkit  #
# order of 'prefetch --option-f *.txt' #
########################################

set -e

# configurations
SCRIPT=$(readlink -f $0) # grep the symlink of this script
SCRIPT_PATH=$(dirname ${SCRIPT}) # 

echo "${SCRIPT}"
echo "${SCRIPT_PATH}"

SRATOOLKIT=${SCRIPT_PATH}/sratoolkit
PREFETCH=

# default
PREFIX="ezsradl"

# 0.prepocessing
while getopts "p:f:s:h" option; do
    case "${option}" in
        p) PREFIX=${OPTARG}
        f) FILE=${OPTARG}
        s) SINGLE=${OPTARG}
        h) echo "Usage: $0 -f <FILE_multi.txt> [options] \
                           -s <FILE_single.txt> \
                           -p output prefix [ezsradl]"
        *) exit 1
    esac
done

base1=$(basename ${FILE} .txt)
base2=$(basename ${SINGLE} .txt)
echo ${base}

if [ -z "${FILE}" ] || [ -z "${SINGLE}" ]; then
    echo "Usage: $0 -f <FILE_multi.txt> [options]"
    echo "          -s <FILE_single.txt>"
    echo "          -p output prefix [ezsradl]"
if

# Defining fuction
ez_sra() {
    num=$(cat ${base1}.txt)
    for name in $num
    do
        echo ${name}
        echo "Then downloading ${name} ..."
        prefetch ${name} 1>> log.txt 2>>&1
        echo "${name} is comlished" 
    done
    echo "All the download of sra are complished "
    echo "The total process took "
}

normal_pref() {
    echo "processing the only one AC..." && \
    sort ${myfile2} |parallel -1 "prefetch {}" |more
}

# run_sra_dl
if [-e ${PREFIX}.runs.done ]; then
    echo "All the files are done"
else 
    echo "Precessing downloading..."
    myfile1=${FILE}
    myfile2=${SINGLE}
    if [! -d "${SCRIPT_PATH}/${myfile1}" ] || [! -d "${SCRIPT_PATH}/${myfile2}"]; then
        echo "${myfile1} || ${myfile2} is not existed"
        echo "Please copy the run_acc.txt to the working directory"
    #
    else
        echo "${myfile1} || ${myfile2} is exsited, now processing..."
    fi
    
    temp_len=`cat $SCRIPT_PATH/${myfile} |wc -l`
    if [ ${temp_len} -lt 1]; then
        echo "Empty txt file!"
    
    else 
        while [ ${temp_len} -gt 1]; \
        do
            echo "Going on..."
        #
        if [ ${temp_len} -eq 1]; \
        then
            echo "There is only one accession number..." && ${normal_pref}  
        #      
        elif [${temp_len} -gt 1]; \
        #
        then
        echo "Runing batch sra downloading..." && ${ez_sra}

    fi

    touch ${PREFIX}.runs.done
fi

