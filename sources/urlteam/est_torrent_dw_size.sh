#! /bin/bash
for F in torrents/*.torrent; do aria2c --show-files=true --dir="./download" --torrent-file $F | grep 'Total Length:'; done | cut -d'(' -f2 | tr -d ')' | tr -d , | tr '\n' '+' | head -c -1 | sed -e 's#^#(#' -e 's#$#)/1024/1024/1024\n#' | bc | tr -d '\n'; echo "GB (gibibyte)"
