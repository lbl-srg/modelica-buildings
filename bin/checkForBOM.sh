#!/bin/bash
for ff in `find . -name '*.mo'`; do
  sed -i 1s/'^\xEF\xBB\xBF'// $ff;
done
retVal=`git status --porcelain .`
if [ "x${retVal}" != "x" ]; then
  echo "Error, found BOM in the following files:"
  git diff .
fi;
test -z "$(git status --porcelain .)"
