#!/bin/sh

# cointool.sh

# First version: Tue Jan 16 17:58:43 JST 2018
# Last update: Tue 12 Dec 14:43:19 JST 2023 by hohno_at_kuimc

set +x
echo
echo "--------"
(export LC_ALL=C; date)
echo "--------"
set -x

export LANG=C
export LC_ALL=C
cd $HOME

pid=$$
mail_cmd="$HOME/bin/klara1_OpeningMessage.sh"
mail_cmdopt="-v"
# mail_addr="hohno46466+klara1bot@gmail.com"
# mail_addr="monkteam@ml.kanazawa-u.ac.jp"
mail_addr="monkteam-bot@ml.kanazawa-u.ac.jp"

randnum=$(bash -c 'echo $RANDOM')
dotcoin=.coinX-$(hostname)
remotecoin=$HOME/.remoteCoin-${hostname}
remotehost=e-ark.sakura.ne.jp
remoteuser=e-ark
remoteport=12222
remoteport=$(expr 12000 + $randnum % 16384)
locallog=$HOME/log${dotcoin}.txt

FMODE=""
if [ "x$1" = "x-f" ]; then
  FMODE="Y"
fi

if [ "x$FMODE" = "xY" ] ; then
  now=$(date +%s)
  start=$now
  maxtime="1800"
  maxtimelimit="1800"

else
  rm -f $remotecoin
  scp -i $HOME/.ssh/id_rsa-dotcoin $remoteuser@$remotehost:$dotcoin $remotecoin || exit 9

  xxx=$(cat -v $remotecoin | grep -v ^# | fold -40 | head -1)
  set $xxx
  start="$1"
  maxtime="$2"

  now=$(date +%s)
  maxtimelimit="1800"
fi

if [ "x$FMODE" = "xY" ]; then
  : echo OK to start.

elif [ "x$start" = "x" -o "x$maxtime" = "x" -o "$start" -lt "$now" -o "$maxtime" -gt "$maxtimelimit" ]; then
  echo "current time: [$now]"
  echo "start time: [$start]"
  echo "maxtime: [$maxtime]"

  echo "*** NG to start. ***"

  exit 2

else
  : echo OK to start.

fi

utcdate=$(date -u)

(echo; date; echo) >> $locallog

echo ssh -i $HOME/.ssh/id_rsa-dotcoin -T -R $remoteport:localhost:22 $remoteuser@$remotehost "(date; echo '#' $utcdate > ${dotcoin}.$remoteport; /bin/mv ${dotcoin} ${dotcoin}.$remoteport; sleep $maxtime; date)" 3>&1 | tee -a $locallog | $mail_cmd $mail_cmdopt $mail_addr

ssh -i $HOME/.ssh/id_rsa-dotcoin -T -R $remoteport:localhost:22 $remoteuser@$remotehost "(date; echo '#' $utcdate > ${dotcoin}.$remoteport; /bin/mv ${dotcoin} ${dotcoin}.$remoteport; sleep $maxtime; date)" 2>&1 >> $locallog

(echo; date; echo; echo "--------") >> $locallog

exit 0


####

# (sleep $maxtime; ps jx | awk '{ if (($1 == '$pid') && ($10 == "ssh")) {print $2} }' | awk 'BEGIN{printf "ps j "} {printf "%d ", $1} END{printf"\n"}' | sh | $dmtweet -t $tweetuser ) &
# (sleep $(expr $maxtime + 5); ps jx | awk '{ if (($1 == '$pid') && ($10 == "ssh")) {print $2} }' | awk 'BEGIN{printf "kill -KILL "} {printf "%d ", $1} END{printf"\n"}' | sh -x ) &

