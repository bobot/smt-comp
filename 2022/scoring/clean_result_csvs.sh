#!/bin/bash

SCRIPTDIR=`dirname $(readlink -f "$0")`

PROCESS_CSV="$SCRIPTDIR/../../tools/process-results/process_results.py"
RESULT_DIR="$SCRIPTDIR/../results"
NONINC_DECISION="$SCRIPTDIR/../results/sq-disagreements-decision.csv"
EXCLUDED="$SCRIPTDIR/../prep/SMT-LIB_excluded.txt"

TMPDIR=$(mktemp -d)
trap "rm -rf $TMPDIR" EXIT

grep ^incremental $EXCLUDED | cut -d/ -f2- > excluded_incremental.txt
grep ^non-incremental $EXCLUDED | cut -d/ -f2- > excluded_nonincremental.txt

for i in inc mv sq uc pe cloud parallel; do
    if [ "$i" == "inc" ]; then
        EXCLUDED=excluded_incremental.txt
        DECISION=""
    else
        EXCLUDED=excluded_nonincremental.txt
        DECISION="-d $NONINC_DECISION"
    fi

    FILTER=""
    if [ "$i" == "uc" ]; then
        FILTER="| grep -v -e ',post-processor error,' -e 'run script error'"
    fi

    echo $PROCESS_CSV -x ${EXCLUDED} ${DECISION} $RESULT_DIR/raw-results-$i.csv
    eval $PROCESS_CSV -x ${EXCLUDED} ${DECISION} $RESULT_DIR/raw-results-$i.csv  $FILTER > results-$i.csv
done
