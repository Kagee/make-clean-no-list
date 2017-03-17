#! /bin/bash
find . -type d -name 'CC-MAIN*' | \
while read DIR;
do
  #EXIT_STATUS=0;
  echo $DIR
  ls $DIR/* | grep ".gz" | \
  while read FILE;
    do gzip --test $FILE; # || EXIT_STATUS=$?;
  done; 
  # echo $DIR: $EXIT_STATUS; # NO WORKY ?_?
done;
