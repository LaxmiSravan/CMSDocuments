# !/bin/sh

set -x
echo "************Get Nodes script**********************************"
cellName=$1
dmgrdir=`ps -ef|grep dmgr|grep $cellName |sed 's/.*\Dserver.root=\(.*\)/\1/' |cut -d' ' -f1`
echo "DMGR folder path->>>>>>>>>>>>>>>>>>>>>>:" $dmgrdir
owner=`ls -ld $dmgrdir |cut -d' ' -f3`
group=`ls -ld $dmgrdir |cut -d' ' -f4`
echo $owner $group

dmgr=$(basename $dmgrdir)
echo "$dmgrdir====>>>>" $dmgr
profiles=""
dirs=`ls -l $dmgrdir/.. | grep '^d'|awk -F" " '{print $9}'`
echo "dirs are-->" $dirs

for Dir in $dirs
do
   FolderName=$(basename $Dir)
   if [ "$FolderName" != "$dmgr" ]
   then
     if [ -n $profiles ]
      then
        profiles="$profiles $FolderName"
		echo " Profiles" $profiles
      else
        profiles="$FolderName"
		echo "profiles" $profiles
      fi
   fi
done
echo dmgr=$dmgr
echo profiles=$profiles
echo profile:
for profile in $profiles
do
   echo $profile
echo "dmgrName:"$dmgr	
#echo "serverName:"$serverName
  profileNode=`echo $profile|sed -e 's/Profile//g'`"Node"
echo "profileNode:"$profileNode
profileName=$profile
echo "profileName:"$profileName
break
done


