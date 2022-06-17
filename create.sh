#!/bin/sh
MOLS=~/cyt-c-charmm/mols
TOP=~/cyt-c-charmm/ff/topol.top
cwd="$(pwd)"

create(){
# use as: create 10-wtperc 450 ch.pdb 456 ac.pdb 452 water.pdb
# 6 extra anions to neutralise charge
mkdir $1
cd $1
gmx editconf -f $MOLS/cytc.pdb -c -box 7 7 7 -o pack.gro
gmx insert-molecules -f pack.gro -ci $MOLS/$3 -nmol $2 -o pack.gro
gmx insert-molecules -f pack.gro -ci $MOLS/$5 -nmol $4 -o pack.gro
gmx insert-molecules -f pack.gro -ci $MOLS/$7 -nmol $6 -o pack.gro
find . -name '#*' -delete
# add mols to topology
mol1="$(echo $3 | sed 's/.pdb//')"
mol2="$(echo $5 | sed 's/.pdb//')"
mol3="$(echo $7 | sed 's/.pdb//')"
cp $TOP . 
cat << EOF >> topol.top 
$mol1 $2
$mol2 $4
$mol3 $6
EOF
cd $cwd
}

printf "%s" "Creating 10 wt % ... "
create 10-wtperc 450 ch.pdb 456 ac.pdb 452 water.pdb >& create_10.txt
echo "Done"
printf "%s" "Creating 20 wt % ... "
create 20-wtperc 400 ch.pdb 406 ac.pdb 905 water.pdb >& create_20.txt
echo "Done"
printf "%s" "Creating 30 wt % ... "
create 30-wtperc 350 ch.pdb 356 ac.pdb 1358 water.pdb >& create_30.txt
echo "Done"
printf "%s" "Creating 40 wt % ... "
create 40-wtperc 300 ch.pdb 306 ac.pdb 1811 water.pdb >& create_40.txt
echo "Done"
printf "%s" "Creating 50 wt % ... "
create 50-wtperc 250 ch.pdb 256 ac.pdb 2264 water.pdb >& create_50.txt
echo "Done"
