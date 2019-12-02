#!/bin/bash
[ -z $1 ] && echo "need 1st arg to be git repo name" && exit
GENV=$1
[[ ! -d ${GENV} ]]  && mkdir ${GENV} 

cd ${GENV}
 if [[ ! -d .git ]]; then
   git clone http://139.169.202.195:3000/tmoore/${GENV}.git .
   git lfs install
   cp ../.gitattributes .
   git add .gitattributes
   git commit -m "adding .gitattributes"
   git push 
   #git push --set-upstream origin ${GENV} 
   for i in flight ground labtest ;
   do 
     git checkout -b $i
   done
   git push origin --all
 fi
cd ..
