#! /bin/bash
#set -e
#set -x
START="$1"
END="$2"
BASE_URL='http://web.archive.org/cdx/?url=*.no&fl=original&collapse=original&output=json&gzip=true&'

if [ "$START" = '--numpages' ]; then
 curl -s "$URL"showNumPages=true | gzip -d;
 exit 1;
fi

echo "START:$START END:$END TIMEOUT:$TIMEOUT"

mkdir -p data/
mkdir -p data-ok/

for I in $(seq $START $END);
do
  ZFI="$(printf "%05d" ${I})"
  PAGE_URL="${BASE_URL}page=${I}"
  PATH_OK="data-ok/${ZFI}.json"
  PATH_DW="data/${ZFI}.json.gz"
  if [ ! -f "${PATH_DW}" ]; then
    echo Downloading $PAGE_URL;
    curl -s "$PAGE_URL" > "$PATH_DW"
  fi
done;

exit 1

do 
  SLP=0
  P="data/${I}.json"
  #POK="data-ok/$(printf "%05d" ${I}).json"
  POKZ="data-ok/$(printf "%05d" ${I}).json.7z"
  if [ ! -f "${POKZ}" ]; then
    if [ ! -f "${P}" ]; then
      echo "${I} GET START:$START END:$END TIMEOUT:$TIMEOUT"
      wget -q -O "${P}" "${URL}${I}";
      SLP=1
      echo "${I} LINT START:$START END:$END TIMEOUT:$TIMEOUT"
      ERROR=$(jsonlint "${P}"; echo $?;)
      if [ $ERROR -gt 0 ]; then
        echo "${I} ERROR"
	#exit 1
      else
        echo "${I} OK START:$START END:$END TIMEOUT:$TIMEOUT"
        #mv "${P}" "${POK}"
	7z a -bd "${POKZ}" "${P}"
	rm -f "${P}"
	#exit 1
      fi
    else
      echo "${I} FOUND"
      ERROR=$(jsonlint "${P}"; echo $?;)
      if [ $ERROR -gt 0 ]; then
        echo "${I} ERROR"
        echo "${I} GET START:$START END:$END TIMEOUT:$TIMEOUT"
        wget -q -O "${P}" "${URL}${I}";
        SLP=1
        echo "${I} LINT START:$START END:$END TIMEOUT:$TIMEOUT"
        ERROR=$(jsonlint "${P}"; echo $?;)
        if [ $ERROR -gt 0 ]; then
          echo "${I} ERROR"
	  #exit 1
        else
          echo "${I} OK START:$START END:$END TIMEOUT:$TIMEOUT"
          #mv "${P}" "${POK}"
	  7z a -bd "${POKZ}" "${P}"
	  rm -f "${P}"
	  #exit 1
        fi
      else
        echo "${I} OK START:$START END:$END TIMEOUT:$TIMEOUT"
        #mv "${P}" "${POK}"
	7z a -bd "${POKZ}" "${P}"
	rm -f "${P}"
	#exit 1
      fi
    fi
  else
    echo "${I} OK-OK START:$START END:$END TIMEOUT:$TIMEOUT"
  fi
  if [ $SLP -gt 0 ]; then
    echo "${I} SLEEP START:$START END:$END TIMEOUT:$TIMEOUT"
    sleep $TIMEOUT
  fi
done;