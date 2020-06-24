#!/bin/bash

SOLVERS_CSV=../../registration/solvers_divisions_final.csv
MAKESPACES=./make_spaces.sh

MV_XML=model-validation.xml
UC_XML=unsat-core.xml
INC_XML=incremental.xml
SQ_XML=single-query.xml

MAIN_SOLVERS_CSV=$(mktemp)
csvgrep -i -c 7 -r '^201[89]-.*$' ${SOLVERS_CSV} > ${MAIN_SOLVERS_CSV}

${MAKESPACES} --sq ${SQ_XML}
${MAKESPACES} --mv ${MV_XML}
${MAKESPACES} --uc ${UC_XML}
${MAKESPACES} --inc ${INC_XML}

rm ${MAIN_SOLVERS_CSV}

tar zcf ${SQ_XML}.tar.gz ${SQ_XML}
tar zcf ${MV_XML}.tar.gz ${MV_XML}
tar zcf ${UC_XML}.tar.gz ${UC_XML}
tar zcf ${INC_XML}.tar.gz ${INC_XML}

