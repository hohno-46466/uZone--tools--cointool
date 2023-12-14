#!/bin/sh

# Last update: Fri 15 Dec 07:09:23 JST 2023 by @hohno_at_kuimc

MAIL_DEBUG=
MAIL_VERBOSE=
# TO_ADDR="hohno.46466+klara1bot@gmail.com"
# TO_ADDR="monkteam@ml.kanazawa-u.ac.jp"
TO_ADDR="monkteam-bot@ml.kanazawa-u.ac.jp"
MAIL_HEADER_FILE="$HOME/workspace/msmtp/klara1_mail_header.sample"

if [ ! -f $MAIL_HEADER_FILE ]; then
  exit 1
fi

OPTS=$(getopt vd $*) || exit 2
set -- $OPTS
for opt in "$@"; do
  case $opt in
    -d) MAIL_DEBUG="-d"; shift ;;
    -v) MAIL_VERBOSE="-v"; shift;;
    --) shift; break;;
  esac
done

if [ "x$1" != "x" ]; then
  TO_ADDR="$1"
fi

# echo "verbose: [$MAIL_VERBOSE]"
# echo "debug: [$MAIL_DEBUG]"
# echo "TO_ADDR: [$TO_ADDR]"
# exit

mymail() {
  if [ "x$MAIL_DEBUG" = "x-d" ]; then
    cat -n
  else
    msmtp $MAIL_VERBOSE $TO_ADDR
  fi
}

(cat $MAIL_HEADER_FILE | sed "s/^To:.*$/To: $TO_ADDR/"
echo
cat << --EOF--
This is a message from user $USER on $(hostname) on $(/bin/date)
これは、$(/bin/date) 時点での $(hostname) 上のユーザ $USER からのメッセージです。

(1) IP アドレス
  $(hostname -I)

(2) 稼働状況
  $(uptime)

(3) SSH の状況
$(ps axw | grep ssh | egrep -v 'ssh-|grep ssh' | sed 's/^/  /')

(4) SSH トンネルの状況
  下記の「参考情報」を参照のこと（ヒントあり）

(5) Tips（トンネル掘削方法）
  例：$ ssh -A -p トンネル用ポート番号 pi@localhost
  例：$ ssh -A -o IdentitiesOnly=yes -i 公開鍵認証用の鍵 -p トンネル用ポート番号 pi@localhost

Please ignore this email. But if you find any problems, let me know. (hohno)
とりあえず無視してください。でも何かおかしな点があれば遠慮なく指摘してください。(hohno)

[参考情報]
(ここから)
--EOF--
cat
echo "(ここまで)"
) |  mymail

