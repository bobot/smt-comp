#!/bin/bash

SOLVERS_CSV=../../registration/solvers_divisions_final.csv
MAKESPACES=./make_spaces.sh

MV_XML=model-validation.xml
UC_XML=unsat-core.xml
INC_XML=incremental.xml
SQ_XML=single-query.xml

MAIN_SOLVERS_CSV=$(mktemp)

echo "Note! This script is designed for year 2020."
echo "The script will not be safe next year."

csvgrep -i -c "Solver Name" -r '^(20[0-9][0-9]-.*|.*-fixed)$' ${SOLVERS_CSV} > ${MAIN_SOLVERS_CSV}

${MAKESPACES} --sq ${SQ_XML} --solvdiv ${MAIN_SOLVERS_CSV}
${MAKESPACES} --mv ${MV_XML} --solvdiv ${MAIN_SOLVERS_CSV}
${MAKESPACES} --uc ${UC_XML} --solvdiv ${MAIN_SOLVERS_CSV}
${MAKESPACES} --inc ${INC_XML} --solvdiv ${MAIN_SOLVERS_CSV}

rm ${MAIN_SOLVERS_CSV}

tar zcf ${SQ_XML}.tar.gz ${SQ_XML}
tar zcf ${MV_XML}.tar.gz ${MV_XML}
tar zcf ${UC_XML}.tar.gz ${UC_XML}
tar zcf ${INC_XML}.tar.gz ${INC_XML}

