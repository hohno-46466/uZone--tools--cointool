#! /bin/sh

# cointool.sh

# Fist version: Tue Jan 16 17:58:43 JST 2018

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
tweetuser=hohno_at_kuimc
dmtweet="$HOME/bin/kotoriotoko/BIN/dmtweet.sh"

randnum=`bash -c 'echo $RANDOM'`
dotcoin=.coinX
remotecoin=$HOME/.remotecoinX
remotehost=e-ark.sakura.ne.jp
remoteuser=e-ark
remoteport=12222
remoteport=`expr 12000 + $randnum % 16384`
locallog=$HOME/log${dotcoin}.txt

rm -f $remotecoin
scp -i $HOME/.ssh/id_rsa-dotcoin $remoteuser@$remotehost:$dotcoin $remotecoin || exit 9

xxx=`cat -v $remotecoin | grep -v ^# | fold -40 | head -1`
set $xxx
start="$1"
maxtime="$2"

now=`date +%s`
maxtimelimit="1800"

if [ "x$start" = "x" -o "x$maxtime" = "x" -o "$start" -lt "$now" -o "$maxtime" -gt "$maxtimelimit" ]; then

  echo "current time: [$now]"
  echo "start time: [$start]"
  echo "maxtime: [$maxtime]"

  echo "*** NG to start. ***"

  exit 2

else

  : echo OK to start.

fi

# (sleep $maxtime; ps jx | awk '{ if (($1 == '$pid') && ($10 == "ssh")) {print $2} }' | awk 'BEGIN{printf "ps j "} {printf "%d ", $1} END{printf"\n"}' | sh | $dmtweet -t $tweetuser ) &
# (sleep `expr $maxtime + 5`; ps jx | awk '{ if (($1 == '$pid') && ($10 == "ssh")) {print $2} }' | awk 'BEGIN{printf "kill -KILL "} {printf "%d ", $1} END{printf"\n"}' | sh -x ) &

(echo; date; echo) >> $locallog
echo ssh -i $HOME/.ssh/id_rsa-dotcoin -T -R $remoteport:localhost:22 $remoteuser@$remotehost "(date; /bin/mv ${sorcoin} ${dotcoin}.$remoteport; sleep $maxtime; date)" 2>&1 | tee -a $locallog | $dmtweet -t $tweetuser
ssh -i $HOME/.ssh/id_rsa-dotcoin -T -R $remoteport:localhost:22 $remoteuser@$remotehost "(date; /bin/mv ${dotcoin} ${dotcoin}.$remoteport; sleep $maxtime; date)" 2>&1 >> $locallog
(echo; date; echo; echo "--------") >> $locallog

exit 0

