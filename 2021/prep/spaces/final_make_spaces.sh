SOLVERS_CSV="../../registration/solvers_divisions_final.csv"
SELECTION=final
export SOLVERS_CSV SELECTION

mkdir -p $SELECTION

./make_spaces.sh --include-nc --mv $SELECTION/mv.xml --uc $SELECTION/uc.xml --inc $SELECTION/inc.xml --sq $SELECTION/sq.xml

cd $SELECTION
for i in sq inc mv uc; do
   tar czf $i.tar.gz $i.xml
done
