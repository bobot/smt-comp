#!/bin/bash

TESTING=0
SQONLY=1
YEAR=2023
SCRIPTDIR=`dirname $(readlink -f "$0")`

if [ $TESTING == 1 ]; then
    mkdir -p testing

    # use last year's seed
    SEED=$(cat ../../../$(expr $YEAR - 1)/COMPETITION_SEED)

    FILTER_NONINC="$SCRIPTDIR/../SMT-LIB_non_incremental_benchmarks_all_assertions.csv"

    OUT_SQ="testing/benchmark_selection_single_query"
    OUT_INC="testing/benchmark_selection_incremental"
    OUT_MV="testing/benchmark_selection_model_validation"
    OUT_UC="testing/benchmark_selection_unsat_core"
    OUT_PE="testing/benchmark_selection_proof_exhibition"

    RATIO=0.001
    NUM_LOWER=5
    PE_RATIO=0.001
    PE_NUM_LOWER=5
else
    mkdir -p final

    SEED=$(cat ../../COMPETITION_SEED)

    FILTER_NONINC="$SCRIPTDIR/../SMT-LIB_non_incremental_benchmarks_all_assertions_sqSolved.csv"

    OUT_SQ="final/benchmark_selection_single_query"
    OUT_INC="final/benchmark_selection_incremental"
    OUT_MV="final/benchmark_selection_model_validation"
    OUT_UC="final/benchmark_selection_unsat_core"
    OUT_PE="final/benchmark_selection_proof_exhibition"

    RATIO=0.5
    NUM_LOWER=300
    PE_RATIO=0.25
    PE_NUM_LOWER=150
fi

echo "Seed: $SEED"

BASEDIR=$SCRIPTDIR/../../..
SELECT="$BASEDIR/tools/selection/selection.py"

BENCHMARKS_SQ="$SCRIPTDIR/../SMT-LIB_non_incremental_benchmarks_all.txt"
NEW_SQ_CSV="$SCRIPTDIR/../SMT-LIB_non_incremental_benchmarks_new.txt"
FILTER_SQ_CSV_2018="$BASEDIR/2018/csv/Main_Track.csv"
FILTER_SQ_CSV_2019="$BASEDIR/2019/results/Single_Query_Track.csv"
FILTER_SQ_CSV_2020="$BASEDIR/2020/results/Single_Query_Track.csv"
FILTER_SQ_CSV_2021="$BASEDIR/2021/scoring/results-sq.csv"
FILTER_SQ_CSV_2022="$BASEDIR/2022/scoring/results-sq.csv"
FILTER_SQ="--filter $FILTER_SQ_CSV_2022 --filter $FILTER_SQ_CSV_2021 --filter $FILTER_SQ_CSV_2020 --filter $FILTER_SQ_CSV_2019 --filter $FILTER_SQ_CSV_2018"

BENCHMARKS_INC="$SCRIPTDIR/../SMT-LIB_incremental_benchmarks_all.txt"
NEW_INC_CSV="$SCRIPTDIR/../SMT-LIB_incremental_benchmarks_new.txt"

BENCHMARKS_UC="$SCRIPTDIR/../SMT-LIB_non_incremental_benchmarks_all.txt"
NEW_UC_CSV="$SCRIPTDIR/../SMT-LIB_non_incremental_benchmarks_new.txt"
FILTER_UC_CSV="$FILTER_NONINC"

BENCHMARKS_PE="$SCRIPTDIR/../SMT-LIB_non_incremental_benchmarks_all.txt"
NEW_PE_CSV="$SCRIPTDIR/../SMT-LIB_non_incremental_benchmarks_new.txt"
FILTER_PE_CSV="$FILTER_NONINC"

# jq -r '.track_model_validation|join(";")' < divisions.json
MV_LOGICS="QF_ABV;QF_ABVFP;QF_ABVFPLRA;QF_ALIA;QF_ANIA;QF_AUFBV;QF_AUFBVFP;QF_AUFLIA;QF_AUFNIA;QF_AX;QF_BV;QF_BVFP;QF_BVFPLRA;QF_DT;QF_FP;QF_FPLRA;QF_IDL;QF_LIA;QF_LIRA;QF_LRA;QF_NIA;QF_NIRA;QF_NRA;QF_RDL;QF_UF;QF_UFBV;QF_UFBVDT;QF_UFDT;QF_UFDTLIA;QF_UFDTLIRA;QF_UFDTNIA;QF_UFFP;QF_UFFPDTNIRA;QF_UFIDL;QF_UFLIA;QF_UFLRA;QF_UFNIA;QF_UFNRA"
BENCHMARKS_MV="$SCRIPTDIR/../SMT-LIB_non_incremental_benchmarks_all.txt"
NEW_MV_CSV="$SCRIPTDIR/../SMT-LIB_non_incremental_benchmarks_new.txt"
FILTER_MV_CSV="$FILTER_NONINC"

# Note that python2 and python3 disagree on random choice function.
# Always use python3 to get reproducible results.
PYTHON=python3

printf "+++++++++++\n\nSQ TRACK\n\n"
$PYTHON $SELECT $FILTER_SQ --benchmarks "$BENCHMARKS_SQ" --new-benchmarks "$NEW_SQ_CSV" -s $SEED --print-stats --out "$OUT_SQ" --prefix "/non-incremental/" --ratio $RATIO --min-per-logic $NUM_LOWER --year $YEAR

if [ "$SQONLY" != "1" ]; then
printf "+++++++++++\n\nMV TRACK\n\n"
$PYTHON $SELECT --benchmarks "$BENCHMARKS_MV" --new-benchmarks "$NEW_MV_CSV" -s $SEED --print-stats --out "$OUT_MV" --prefix "/non-incremental/" --logic "$MV_LOGICS" --sat "$FILTER_MV_CSV" --ratio $RATIO --min-per-logic $NUM_LOWER --year $YEAR

printf "+++++++++++\n\nINC TRACK\n\n"
$PYTHON $SELECT --benchmarks "$BENCHMARKS_INC" --new-benchmarks "$NEW_INC_CSV" -s $SEED --print-stats --out "$OUT_INC" --prefix "/incremental/" --ratio $RATIO --min-per-logic $NUM_LOWER --year $YEAR

printf "+++++++++++\n\nUC TRACK\n\n"
$PYTHON $SELECT --benchmarks "$BENCHMARKS_UC" --new-benchmarks "$NEW_UC_CSV" -s $SEED --print-stats --out "$OUT_UC" --prefix "/non-incremental/" --unsat "$FILTER_UC_CSV" --ratio $RATIO --min-per-logic $NUM_LOWER --year $YEAR

printf "+++++++++++\n\nPE TRACK\n\n"
$PYTHON $SELECT --benchmarks "$BENCHMARKS_PE" --new-benchmarks "$NEW_PE_CSV" -s $SEED --print-stats --out "$OUT_PE" --prefix "/non-incremental/" --unsat "$FILTER_PE_CSV" --n-asserts 0 --ratio $PE_RATIO --min-per-logic $PE_NUM_LOWER --year $YEAR
fi
