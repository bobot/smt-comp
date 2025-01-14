#! /bin/bash

#SCRIPTDIR=`dirname $(greadlink -f "$0")`
SCRIPTDIR=`dirname $(readlink -f "$0")`

OUTPUT=../results/_results_2020
LANG=C

PYTHON=python3
SCORE="$SCRIPTDIR/../../tools/scoring/score.py"
FILTER="$SCRIPTDIR/../../tools/scoring/filter_result_csv.py"

RESULTS_SQ="$SCRIPTDIR/../results/Single_Query_Track.csv"
RESULTS_INC="$SCRIPTDIR/../results/Incremental_Track.csv"
RESULTS_UC="$SCRIPTDIR/../results/Unsat_Core_Track.csv"
RESULTS_MV="$SCRIPTDIR/../results/Model_Validation_Track.csv"

cat blacklist_nonincremental_*.txt | sort -u > blacklist_nonincremental.txt
cat blacklist_incremental_*.txt | sort -u > blacklist_incremental.txt

BLACKLIST_SQ="blacklist_nonincremental.txt"
BLACKLIST_UC="blacklist_nonincremental.txt"
BLACKLIST_MV="blacklist_nonincremental.txt"
BLACKLIST_INC="blacklist_incremental.txt"


INC_NUM_CHECK_SAT="$SCRIPTDIR/../prep/SMT-LIB_incremental_benchmarks_num_check_sat.csv"

TIME=1200

SOLVERS_CSV="$SCRIPTDIR/../registration/solvers_divisions_final.csv"

GEN_SQ=
GEN_INC=
GEN_UC=
GEN_MV=

while [ $# -gt 0 ]
do
  case $1 in
    -h|--help)
      echo -n "usage: $(basename $0) [<option>]"
      echo
      echo "Generate results .md files for website."
      echo
      echo "  options:"
      echo "    -h, --help     Print this message and exit"
      echo "    --all          All tracks"
      echo "    --sq           Single Query track (no strings)"
      echo "    --inc          Incremental track "
      echo "    --uc           Unsat Core track "
      echo "    --mv           Model Validation track "
      echo
      exit
      ;;
    --all)
      GEN_SQ=yes
      GEN_INC=yes
      GEN_UC=yes
      GEN_MV=yes
      ;;
    --sq)
      GEN_SQ=yes
      ;;
    --inc)
      GEN_INC=yes
      ;;
    --uc)
      GEN_UC=yes
      ;;
    --mv)
      GEN_MV=yes
      ;;
    -*)
        echo "ERROR: invalid option '$1'"
        exit 1
      ;;
    *)
      break
  esac
  shift
done

mkdir -p $OUTPUT

[[ -n $GEN_SQ ]] && \
$PYTHON $FILTER $RESULTS_SQ --exclude $BLACKLIST_SQ > sq-filtered.csv && \
$PYTHON $SCORE -y 2020 --csv sq-filtered.csv  -t $TIME --gen-md $OUTPUT -T sq -S $SOLVERS_CSV
[[ -n $GEN_INC ]] && \
$PYTHON $FILTER $RESULTS_INC --exclude $BLACKLIST_INC > inc-filtered.csv && \
$PYTHON $SCORE -y 2020 --csv inc-filtered.csv -t $TIME --gen-md $OUTPUT -T inc -S $SOLVERS_CSV -i $INC_NUM_CHECK_SAT
[[ -n $GEN_UC ]] && \
$PYTHON $FILTER $RESULTS_UC --exclude $BLACKLIST_UC > uc-filtered.csv && \
$PYTHON $SCORE -y 2020 --csv uc-filtered.csv  -t $TIME --gen-md $OUTPUT -T uc -S $SOLVERS_CSV
[[ -n $GEN_MV ]] && \
$PYTHON $FILTER $RESULTS_MV --exclude $BLACKLIST_MV > mv-filtered.csv && \
$PYTHON $SCORE -y 2020 --csv mv-filtered.csv  -t $TIME \
    --gen-md $OUTPUT -T mv -S $SOLVERS_CSV \
    --expdivs QF_LIA,QF_IDL,QF_LRA,QF_RDL,QF_LIRA
