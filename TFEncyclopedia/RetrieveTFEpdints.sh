#!/bin/bash

WRONGARGS=1
if [ $# != 1 ]
then
  echo "Usage: `basename $0` <human or mouse> " >&2
  exit $WRONGARGS
fi

species=$1

cut -f 1 /users/thorsson/data/ncbi/gene_info_simplified_$species > rowfile

python RetrieveTFEpdints.py $species > pdints.$species.1.tsv
/users/thorsson/bin/keepRows.py pdints.$species.1.tsv 3 rowfile > pdints.$species.2.tsv
cp -f pdints.$species.2.tsv pdints.${species}.TFEncyclopedia.tsv 
grep user pdints.$species.2.tsv > pdints.$species.3.tsv 
cut -f 1 pdints.$species.3.tsv > t1
python /users/thorsson/bin/AddStringToLines.py t1 " pd " end > t2
cut -f 3 pdints.$species.3.tsv > t3
paste -d ' ' t2 t3 > pdints.$species.TFEncyclopedia.sif

rm -f pdints.$species.?.tsv 
rm -f t1 t2 t3 rowfile




