#! /bin/bash
#set -e
#set -x

if [ "$#" -lt 3 ]; then
    echo "Illegal number of parameters, required: start, end, timeout, optional cmd (--delete-failed)"
    exit 1;
fi

START="$1"
END="$2"
BASE_URL='http://web.archive.org/cdx/?url=*.no&fl=original&collapse=original&output=json&gzip=true&'
TIMEOUT="$3"
CMD="x$4"

if [ "$CMD" = 'x--numpages' ]; then
 curl -s "$URL"showNumPages=true | gzip -d;
 exit 1;
fi

echo "START:$START END:$END TIMEOUT:$TIMEOUT"

mkdir -p data/
mkdir -p data-ok/

SLEEP=0
for I in $(seq $START $END);
do
  ZFI="$(printf "%05d" ${I})"
  echo -n "$ZFI: ."
  PAGE_URL="${BASE_URL}page=${I}"
  PATH_OK="data-ok/${ZFI}.json.gz"
  PATH_DW="data/${ZFI}.json.gz"
  if [ ! -f "${PATH_DW}" ]; then
    if [ $SLEEP -eq 1 ]; then
      echo -n ". sleeping for ${TIMEOUT}s .";
      sleep $TIMEOUT;
      SLEEP=0
    fi
    SLEEP=1
    echo -n ". downloading &page=$ZFI .";
    curl -s "$PAGE_URL" > "$PATH_DW"
  else
    echo -n ". download found .";
  fi
  if [ ! -f "${PATH_OK}" ]; then
    zcat "$PATH_DW" 2>/dev/null | jsonlint-py -s -q
    if [ $? -eq 0 ]; then
      cp "$PATH_DW" "$PATH_OK"
      echo -n ". lintcheck ok .. copied verified file ok!";
    else
      echo -n ". lintcheck FAILED .";
      if [ "$CMD" = "x--delete-failed" ]; then
        rm "$PATH_DW";
        echo -n ". deleting failed download .";
      fi
    fi
  else
    echo -n ". verified file file ok!";
  fi



  echo "";
done;
