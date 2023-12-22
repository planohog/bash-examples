#!/bin/bash
################################################
# used in making puppetlab modules dir tree    #
# run this is a folder full of module.tar.gz   #
# no handrails  very sharp knifes              #
################################################
TDIR=""
NDIR=""
CDIR=$(pwd)
################################################
function utar {
  tar xfz $1
}
################################################
function rmtarball {
  rm $1
}
################################################
function getdir {
  TDIR=$(echo $1 | sed 's/\.tar\.gz//g' )
  echo "TDIR=$TDIR"
  NDIR=$( echo $TDIR | awk -F"-" '{print $2}')
  echo "NDIR=$NDIR"
}
################################################
function mvdir {
# 1 is TDIR 2 is NDIR
  `mv "$CDIR/$1" "$CDIR/$2" `
}
################################################
function mversion {
  echo "$TDIR" > ./${NDIR}/${TDIR}
}
################################################
files=`ls *gz `
for x in $files
do echo "$x"
  utar "$x"
  getdir "$x"
  rmtarball "$x"
  mvdir "$TDIR" "$NDIR"
  mversion
done
################################################
