#!/bin/sh
# parseMetaData
parseMetaData() {
echo "[INFO] parsing metadata......"
	pkgName=`cat $metaData| grep software$loopCount|cut -d '=' -f 2` 
        reqSpace=`cat $metaData| grep space$loopCount|cut -d '=' -f 2` 
        pkgQueryString=`cat $metaData| grep pkgQueryString$loopCount|cut -d '=' -f 2`  

#	echo "$pkgName, $prod, $reqSpace, $installReloc, $inputFile, $pkgQueryString, $theVersion, $pkgsubString"
        }
install() {
echo "[INFO] Installing rpm..."
	if [ $PkgLoc == "gds-prod" ]
    then
    # GDS prod
    pkgLoc=/net/stealth/export1/home1.localhost/sw/Linux
    echo "[INFO] pkgLoc=$pkgLoc"
    else
        if [ $PkgLoc == "/tmp" ]
        then
                pkgLoc=/tmp
        else
                pkgLoc=/net/stealth/export1/home1.localhost/sw/outbound/vtt-testing
        fi

    echo "[INFO] pkgLoc=$pkgLoc"
    fi
   
    dbpath="/var/lib/rpm"
    # get the software count         
    count=`cat $metaData| grep software | wc -l`
    loopCount=0
	while [ $loopCount -lt $count ]
    do
		loopCount=$[loopCount+1]
		parseMetaData
		#PkgRelocation=/opt
		rpmOptions='';
		rpmOptions="$rpmOptions --dbpath $dbpath";
		instOptions="$rpmOptions --prefix $PkgRelocation"; 
		if [ ! -f $pkgLoc/$pkgName ] ; then
			echo "[ERROR] unable to locate package at $pkgLoc/$pkgName"
			exit -1
		fi
		str=`rpm -qa $rpmOptions|grep $pkgQueryString` 
		if [ "XX$str" == "XX" ] ;then
			rpm -ivh $pkgLoc/$pkgName
		else
			echo "[INFO] \"$pkgLoc/$pkgName\" is already installed."
		fi
	done
     
           
    echo "[INFO] Install all the softwares successfully"
    return 0
}

permChange() {
	echo "[INFO] in permchange() ..................."
	$pkgPath/scripts/postinstall.ksh $owner
	if [ $? -ne 0 ] 
	then 
	   echo "failed postinstall"
	   exit -1
	else
	   echo "after running the postinstall"
	fi
} 

getUserEnteredValues()
{

echo " [INFO] in getUserEnteredValues()....."
echo "************USER ENTERED VALUES***********"
srcPath=$pkgPath/scripts
logPath=$pkgPath/log
d2warName="D2.war"
 d2ConfigwarName="D2-Config.war"
d2EarName="D2.ear"
 d2ConfigEarName="D2-Config.ear"
d2warPath="$pkgPath/d245/war/D2.war"
echo "d2warPath===>" $d2warPath
d2ConfigwarPath="$pkgPath/d245/war/D2-Config.war"
echo "d2ConfigwarPath====>" $d2ConfigwarPath
 d2ContextName="/D2"
 d2AppName="D2"
 d2ConfigContextName="/D2-Config"
 d2ConfigAppName="D2-Config"
 LOCKBOX_HOME="$pkgPath/d245/Lockbox"
echo "LOCKBOX_HOME===>>>" $LOCKBOX_HOME
#srcPath=/opt/CITI_DCTMD2App/scripts
#echo " pkgLoc--->" $PkgLoc
restartOps=$RestartOps
AppName=$AppName
echo "[VALUE]AppName---->" $AppName
cellName=$cellName
echo "[VALUE]cellName===>" $cellName
nodeName=$dmgrName"Node"
echo "[VALUE]nodeName ::" $nodeName
runtimeLoc=$RuntimeLoc
echo "[VALUE]runtimeLoc: :" $runtimeLoc
contentServer1=$ContentServer1
echo "[VALUE]contentServer1: :" $contentServer1
contentServer2=$ContentServer2
echo "[VALUE]contetnServer2: :" $contentServer2
host=`hostname -f`
echo "[VALUE]hostfull name: :"$host
path=$(cd "$(dirname "$0")"; pwd)
echo " [VALUE]path>>>>>>>>>>>>>>>>>>>>>>:" $path

PkgRelocation=$PkgRelocation
echo "[VALUE]Package Relocation: :" $PkgRelocation
appLocation=$runtimeLoc/$AppName
echo "[VALUE] appLocation: :" $appLocation
ProfilePath=$runtimeLoc/$AppName/${AppName}_Runtime/profiles
echo "[VALUE]ProfilePath: :" $ProfilePath
cellpath=$runtimeLoc/$AppName
echo "[VALUE]cellHomePath: :" $cellpath
runtimePath=$runtimeLoc/$AppName/${AppName}_Runtime

echo "[VALUE]runtimePath: :" $runtimePath

#procId=`ps -ef|grep dmgr|grep $cellName|wc -l`
#echo "PROC ID**************************" $procId

#if [ $procId == 0 ]
#then

 #echo "The DMGR process is not running: Please make sure the WAS processes are running and try again"

#exit 1

#fi
dmgrdir=`ps -ef|grep dmgr|grep $cellName |sed 's/.*\Dserver.root=\(.*\)/\1/' |cut -d' ' -f1`
echo "[VALUE]DMGR folder path->>>>>>>>>>>>>>>>>>>>>>:" $dmgrdir
owner=`ls -ld $dmgrdir |cut -d' ' -f3`
group=`ls -ld $dmgrdir |cut -d' ' -f4`
echo $owner $group

appFID=$owner
echo "[VALUE] APPFID: :"$appFID
groupID=$group
echo "[VALUE]GroupId: :"$groupID
export SU_GROUPID="/bin/su - $appFID -c"
echo "$SU_GROUPID 'id; $srcPath/getNodes.sh $cellName'"

procId=`ps -ef|grep dmgr|grep $cellName|wc -l`
echo "PROC ID**************************" $procId
if [ $procId == 0 ]
then
 echo "The DMGR process is not running: Please make sure the WAS processes are running and try again"
 exit -1

fi
echo "$pkgPath/scripts/getNodes.sh $cellName>$srcPath/tmp.txt"
$pkgPath/scripts/getNodes.sh $cellName>$srcPath/tmp.txt


profileName=`cat "$srcPath/tmp.txt"|grep "profileName:"|cut -d":" -f2`
#cellName=$AppName"Cell"
echo "[VALUE]profile Name" $profileName

profileNode=`cat "$srcPath/tmp.txt"|grep "profileNode:"|cut -d":" -f2`
echo "[VALUE]ProfileNode::" $profileNode

dmgrName=`cat "$srcPath/tmp.txt"|grep "dmgrName:"|cut -d":" -f2`
nodeName=$dmgrName"Node"
echo "[VALUE]nodeName ::" $nodeName
echo "[VALUE]ProfileNode::" $profileNode
profileNode=$profileName"Node"
hostname=`hostname`
hostspecificnode=$profileNode$hostname
echo "[VALUE]hostspecificnode====>>>>"$hostspecificnode

hostspecificserverIndexFilePath=$ProfilePath/$cellName/$dmgrName/config/cells/$cellName/nodes/$hostspecificnode/serverindex.xml
#portVirtualHost=`awk '/"WC_defaulthost"/{x=NR+1;next}(NR<=x){print}' $hostspecificserverIndexFilePath | awk '{b=$4}END{print b}' | cut -d'"' -f2`
echo "[VALUE]hostspecificserverIndexFilePath====>>>>>>>>" $hostspecificserverIndexFilePath
		dmgrserverIndexFilePath=$ProfilePath/$cellName/$dmgrName/config/cells/$cellName/nodes/$nodeName/serverindex.xml
		echo "[VALUE]dmgrserverIndexFilePath--->>" $dmgrserverIndexFilePath
		
		portBaseDMGR=`awk '/"WC_adminhost"/{x=NR+1;next}(NR<=x){print}' $dmgrserverIndexFilePath | awk '{b=$4}END{print b}' | cut -d'"' -f2`
		echo "[VALUE]portBaseDMGR--->" $portBaseDMGR
		portVirtualHost=`awk '/"WC_defaulthost"/{x=NR+1;next}(NR<=x){print}' $hostspecificserverIndexFilePath | awk '{b=$4}END{print b}' | cut -d'"' -f2`
		echo "[VALUE]virtualHost--->" $portVirtualHost
		portVirtualHostSecure=`awk '/"WC_defaulthost_secure"/{x=NR+1;next}(NR<=x){print}' $hostspecificserverIndexFilePath | awk '{b=$4}END{print b}' | cut -d'"' -f2`
		echo "[VALUE]virtualHost--->" $portVirtualHostSecure
		
		portBaseProfile=`awk '/"BOOTSTRAP_ADDRESS"/{x=NR+1;next}(NR<=x){print}' $hostspecificserverIndexFilePath |awk '{b=$4}{print b}' | cut -d '"' -f2 |head -1`
		echo "[VALUE]virtualHost--->" $portBaseProfile

			WASLIB=$PkgRelocation/$AppName/WebSphere/*/lib
                        echo "WASLIB=====>" $WASLIB
                           WAS_HOME=$PkgRelocation/$AppName
                           echo "[VALUE]WAS_HOME:" $WAS_HOME
                           export EMT_WAS_HOME=$PkgRelocation/$AppName/emt-was/855
                           echo "[VALUE]EMT_WAS_HOME:" $EMT_WAS_HOME
                           export EMT_CORE_HOME=$PkgRelocation/$AppName/emt-was/855
                           #emtWasHome=str(java.lang.System.getenv("EMT_WAS_HOME"))

                           echo "[VALUE]EMT_CORE_HOME:" $EMT_CORE_HOME


nodePath=$ProfilePath/$cellName/$profileName
echo "NODE PATH==============================>>>>>>>" $nodePath
dmgrPath=$ProfilePath/$cellName/$dmgrName
echo "$SU_GROUPID '$nodePath/bin/serverStatus.sh -all' > $srcPath/status.txt"
$SU_GROUPID "$nodePath/bin/serverStatus.sh -all" > $srcPath/status.txt
serverName=`cat "$srcPath/status.txt"|grep "Server name" |awk '{ print $(NF) }'| grep -v -e ^n -e ^W`
echo "SERVER NAME=====>>" $serverName

clusterName=`find $nodePath -name "cluster.xml" |head -1 | xargs grep "name"|awk '{b=$6}{print b}' | cut -d '"' -f2`
echo "CLUSTER NAME============>"$clusterName
D2PW=$D2PW
echo "[VALUE]------>" $D2PW
D2PW=`echo $D2PW|sed -e "s/ //g"`

if [[ $D2PW == "xxxx"  ]]
then
      export D2PW=Welcome1!
else
      export D2PW=`/opt/mstCrypto/encryptdecrypt.sh 2 $D2PW 2>&1`
fi

}

###########
checkNcreateHomencacheDir() {
   homeDir=`getent passwd $owner |cut -d":" -f6`

   if [ -d $homeDir ];  then
	echo "[INFO] home dir for the FID exists"
   else
	echo "[INFO] home dir doesn't exist. Creating one"
   	cp -a /etc/skel $homeDir
   	chown $owner:$group $homeDir
   	chmod -R 755 $homeDir
   	echo "[INFO] created homedir"
  fi
  tmpDir=$pkgPath/d2app
  rm -rf $tmpDir
  mkdir -p $tmpDir
  chown $owner:$group $tmpDir
  chmod -R 777 $tmpDir
}

preConfiguration()
{
echo "in PRE CONFIGURATIon------------->" 
DMGR_ADMIN=`find $ProfilePath -name wsadmin.sh | grep $dmgrName`
echo "[VALUE] DMGR_ADMIN---->" $DMGR_ADMIN
$SU_GROUPID"$srcPath/clearcache.ksh $nodePath $pkgPath"
echo "[INFO]clear the cache"
echo "[INFO]**** Adding vhost"
$SU_GROUPID "id;$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/addvhost.jy $cellName $portVirtualHostSecure $portVirtualHost -trace"
echo "[INFO]**** Added vHost successfull***********y"
echo "EMT_WAS_HOME--------------------->" $EMT_WAS_HOME
echo "EMT_CORE_HOME--------------------->" $EMT_CORE_HOME
echo "$SU_GROUPID "id;$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/setjvmworkdir.py $profileName $EMT_WAS_HOME $EMT_CORE_HOME $serverName $tmpDir -trace""
$SU_GROUPID "id;$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/setjvmworkdir.py $profileName $EMT_WAS_HOME $EMT_CORE_HOME $serverName $tmpDir -trace"
nodePath=$ProfilePath/$cellName/$profileName
dmgrPath=$ProfilePath/$cellName/$dmgrName
echo "nodePath-->" $nodePath
}
postConfiguration()
{
		d2Dir=$ProfilePath/$cellName/$profileName/installedApps/$cellName/$d2EarName
		echo "[VALUE] d2Dir--------------------------->" $d2Dir

		d2LibPath=$d2Dir/$d2warName/WEB-INF/lib
		echo "[VALUE] d2LibPath----------->" $d2LibPath

		d2Lib=$d2LibPath/aspectjrt.jar

		d2ConfigDir=$ProfilePath/$cellName/$profileName/installedApps/$cellName/$d2ConfigEarName
		echo "[VALUE] d2ConfigDir--------------------------->" $d2ConfigDir

		d2ConfigLibDir=$ProfilePath/$cellName/$profileName/installedApps/$cellName/$d2ConfigEarName/$d2ConfigwarName/WEB-INF/lib
		echo "[VALUE] d2ConfigLibDir--------------------------->" $d2ConfigLibDir	
		d2Lib=$d2LibPath/aspectjrt.jar
                 d2SchemaPath=$d2Dir/$d2warName/WEB-INF/schemas
		 webSphereLib=$PkgRelocation/$AppName/WebSphere/85-64/lib
		echo "[VALUE] d2LIBPATH========>" $d2LibPath
                echo "[VALUE] webSphereLib====>" $webSphereLib
		echo "[VALUE] d2SchemaPath====>" $d2SchemaPath
	$SU_GROUPID "$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/createsharedlib.jy $cellName $hostspecificnode $d2Lib -trace"

	cp -p $LOCKBOX_HOME/lib/LB.jar $WASLIB/.
        cp -p $LOCKBOX_HOME/lib/LBJNI.jar $WASLIB/.
        chown root:root $WASLIB/LB.jar
        chown root:root $WASLIB/LBJNI.jar
        chown root:root $WASLIB/LB.jar
        chown root:root $WASLIB/LBJNI.jar


 echo "[INFO] $nodePath in postconfiguration===>" $nodepath
echo "[INFO] $serverName---->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-" $serverName
                echo "$SU_GROUPID "$nodePath/bin/stopServer.sh $serverName""
                setupLockbox

}

##############
setupLockbox() {
	echo "in setupLockbox method---"
	echo "$SU_GROUPID "$srcPath/clearcache.ksh $nodePath""
	echo "$SU_GROUPID "ksh -x $srcPath/clearcache.ksh $nodePath $pkgPath"" >> $srcPath/clearcache.README
	$SU_GROUPID "ksh -x $srcPath/clearcache.ksh $nodePath"
	d2Lib=$d2LibPath/aspectjrt.jar
	echo "$srcPath/setlockboxapp.ksh $WAS_HOME $LOCKBOX_HOME $d2ConfigLibDir $appFID $D2PW $pkgPath"
	$SU_GROUPID "ksh -x $srcPath/setlockboxapp.ksh $WAS_HOME $LOCKBOX_HOME $d2ConfigLibDir $appFID $D2PW $pkgPath"
	
	if [ $? -ne 0 ];then
	    echo "[ERROR]Setting up the Lockbox Failed"
	    exit -1
	else 
	    echo "[INFO]Setting up the Lockbox completed"
	fi
}

###################
startApps()
{
echo "[INFO] restarting the cluster ....................."
NODE_ADMIN=`find $ProfilePath -name wsadmin.sh | grep $profileName`
echo " NODE_ADMIN>>>>>>>>>>>>>>>>>>>>>>>>>>"$NODE_ADMIN


#$SU_GROUPID "$NODE_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/StartApp.py $appName $serverName $nodeName $cellName -trace"

 echo "$SU_GROUPID "$DMGR_ADMIN  -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/StartApp.py D2 $serverName $hostspecificnode $cellName -trace""
 $SU_GROUPID "$DMGR_ADMIN  -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/StartApp.py D2 $serverName $hostspecificnode $cellName -trace"


echo "$SU_GROUPID "$DMGR_ADMIN  -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/StartApp.py D2-Config $serverName $hostspecificnode $cellName -trace""
  $SU_GROUPID "$DMGR_ADMIN  -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/StartApp.py D2-Config $serverName $hostspecificnode $cellName -trace"


if [ $? -ne 0 ]
then
        echo "[ERROR] Failed to restart the cluster"
fi

}

restartCluster()
{
echo "[INFO] restarting the cluster ....................."
NODE_ADMIN=`find $ProfilePath -name wsadmin.sh | grep $profileName`
echo " NODE_ADMIN>>>>>>>>>>>>>>>>>>>>>>>>>>"$NODE_ADMIN
$SU_GROUPID "$NODE_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/restartcluster.py $clusterName $cellName -trace"

if [ $? -ne 0 ]
then
	echo "[ERROR] Failed to restart the cluster"
fi

}
startupScripts()
{
echo "in startup scripts"
echo "nodePath--->" $nodePath
echo "srcPath--->" $srcPath
if [ ! -f $srcPath/stopWAS.ksh ]
                 then
                        echo "Startup scripts for WAS..."
                        echo "$nodePath/bin/stopServer.sh $serverName">>$srcPath/stopWAS.ksh

                        echo "sleep 1" >>$srcPath/stopWAS.ksh
                        echo "$nodePath/bin/stopNode.sh">>$srcPath/stopWAS.ksh
                        echo "sleep 10" >>$srcPath/stopWAS.ksh

                        echo "$dmgrPath/bin/stopManager.sh">>$srcPath/stopWAS.ksh
                        chmod 755 $srcPath/stopWAS.ksh

                fi
                if [ ! -f $srcPath/startWAS.ksh ]
                 then
                        echo "$SU_GROUPID">>$srcPath/startWAS.ksh

                        echo "$dmgrPath/bin/startManager.sh">>$srcPath/startWAS.ksh
                        echo "sleep 10" >>$srcPath/startWAS.ksh
                        echo  "$nodePath/bin/startNode.sh">>$srcPath/startWAS.ksh
                        echo "sleep 10" >>$srcPath/startWAS.ksh
                        echo "$nodePath/bin/startServer.sh $serverName">>$srcPath/startWAS.ksh
                        chmod 755 $srcPath/startWAS.ksh
                fi


}
verifyCellndeploy()
{

checkNcreateHomencacheDir
echo "[INFO] in verifyndeploy() method..................."

#getUserEnteredValues
DMGR_ADMIN=`find $ProfilePath -name wsadmin.sh | grep $dmgrName`

echo "DMGR_ADMIN>>>>>>>>>>>>>>>>>>>>>>>>>>>>" $DMGR_ADMIN

NODE_ADMIN=`find $ProfilePath -name wsadmin.sh | grep $profileName`
echo " NODE_ADMIN>>>>>>>>>>>>>>>>>>>>>>>>>>"$NODE_ADMIN

preConfiguration

d2Dir=$ProfilePath/$cellName/$profileName/installedApps/$cellName/$d2EarName
#echo "d2Dir--------------------------->" $d2Dir

#d2LibPath=$d2Dir/$d2warName/WEB-INF/lib
#echo "d2LibPath----------->" $d2LibPath

#d2Lib=$d2LibPath/aspectjrt.jar

d2ConfigDir=$ProfilePath/$cellName/$profileName/installedApps/$cellName/$d2ConfigEarName
#echo "d2ConfigDir--------------------------->" $d2ConfigDir

#d2ConfigLibDir=$ProfilePath/$cellName/$profileName/installedApps/$cellName/$d2ConfigEarName/$d2ConfigwarName/WEB-INF/lib
#echo "d2ConfigLibDir--------------------------->" $d2ConfigLibDir
#generateXMLforCell


	 if [ -d $runtimeLoc/$AppName/${AppName}_Runtime/profiles/$cellName ]  
	 then 
		echo " cell found with this name. Proceeding with the deployment "
		
		if [ ! -d $d2Dir ]
		then 
		  echo "[INFO]recreating war-------------------------------->"
	          echo "$srcPath/recreatewar.sh $cellName $d2warPath $contentServer1 $contentServer2 D2 $srcPath $LOCKBOX_HOME '$d2log'" 
		  $srcPath/recreatewar.sh $cellName $d2warPath $contentServer1 $contentServer2 D2 $srcPath $LOCKBOX_HOME 
                  echo "[INFO] deploying.............."
		   echo "$SU_GROUPID "$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/installApp.py $srcPath/D2.war $clusterName $d2ContextName $d2AppName -trace""
		  $SU_GROUPID "$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/installApp.py $srcPath/D2.war $clusterName $d2ContextName $d2AppName -trace"
			
		   $SU_GROUPID "$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/chngclassD2.jy -trace"
		  $SU_GROUPID "$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/setclassloaderforappD2.jy -trace"

		else
		echo "*********************************D2 Already Exists***********************"			
			

		fi

		if [ ! -d $d2ConfigDir ]
	         then	
			echo "[INFO] recreating  D2-COnfig war"
		echo "$srcPath/recreatewar.sh $cellName $d2ConfigwarPath $contentServer1 $contentServer2 D2-Config $srcPath $LOCKBOX_HOME "
		 $srcPath/recreatewar.sh $cellName $d2ConfigwarPath $contentServer1 $contentServer2 D2-Config $srcPath $LOCKBOX_HOME 
		 echo "[INFO] deploying D2-Config war"
		 echo "$SU_GROUPID "$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/installApp.py $srcPath/D2-Config.war $clusterName $d2ConfigContextName $d2ConfigAppName -trace""
 		   $SU_GROUPID "$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/installApp.py $srcPath/D2-Config.war $clusterName $d2ConfigContextName $d2ConfigAppName -trace"
		   		   
		   echo "[INFO]changing class loader>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		   
		   $SU_GROUPID "$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/chngclassD2Config.jy -trace"
			$SU_GROUPID "$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/setclassloaderforappD2Config.jy -trace"

	         else
		  echo "*********************D2-Config already exists**************"	
		fi
	
					
	else
	 echo "[ERROR] CELL NOT FOUND .Please create a cell first and proceed with the deployment***********************"
	
		
	fi
     echo "d2Lib---->>>>>>>>" $d2Lib
		#$SU_GROUPID "$DMGR_ADMIN -javaoption "-Xms256m" -javaoption "-Xmx768m" -lang jython -f $srcPath/createsharedlib.jy $cellName $hostspecificnode $d2Lib -trace"

}


#############main###############
paramFile=$1
path=$(cd "$(dirname "$0")"; pwd)
pkgPath="/opt/CITI_DCTMD2AppP22"
srcPath=$pkgPath/scripts
sed -i "s/\"//g" $paramFile
#source parameter file
. $paramFile
metaData=$path/MetaData
# check action type
if [ $InstanceType == "installbinary" ]
echo "**********************************************INSTANCE TYPE *********************" $InstanceType

then
    echo "[INFO] InstanceType Type is \"$InstanceType \", install will start"
    install

    
    if [ $LPAR == S ];then
	echo "-------------------Remote Node--------------------"
	nodedir=`ps -ef|grep 'Profile\|node' |grep $cellName |sed 's/.*\Dserver.root=\(.*\)/\1/' |cut -d' ' -f1|head -1`
	profileName=`awk -F'/' '{print $(NF)}' <<< $nodedir`
	
	echo "[VALUE]Remote node folder path ->:" $nodedir
	
	owner=`ls -ld $nodedir |cut -d' ' -f3`
	group=`ls -ld $nodedir |cut -d' ' -f4`
	
	D2PW=$D2PW
	echo "[VALUE]------>" $D2PW
	D2PW=`echo $D2PW|sed -e "s/ //g"`

	if [[ $D2PW == "xxxx"  ]]
	then
      		export D2PW=Welcome1!
	else
      		export D2PW=`/opt/mstCrypto/encryptdecrypt.sh 2 $D2PW 2>&1`
	fi
	
	permChange
	
	checkNcreateHomencacheDir
	
	# move LB jars to WAS run-time lib
	cp -p $pkgPath/d245/Lockbox/lib/LB*.jar $PkgRelocation/$AppName/WebSphere/*/lib/.
        chown root:root $PkgRelocation/$AppName/WebSphere/*/lib/LB.jar
        chown root:root $PkgRelocation/$AppName/WebSphere/*/lib/LBJNI.jar

  	# set up lockbox
  	d2ConfigEarName="D2-Config.ear"
	d2ConfigwarName="D2-Config.war"

	ProfilePath=$RuntimeLoc/$AppName/${AppName}_Runtime/profiles
  	d2ConfigLibDir=$ProfilePath/$cellName/$profileName/installedApps/$cellName/$d2ConfigEarName/$d2ConfigwarName/WEB-INF/lib
	
	export SU_GROUPID="/bin/su - $owner -c"
  	
  	$SU_GROUPID "$srcPath/setlockboxapp.ksh $PkgRelocation/$AppName $pkgPath/d245/Lockbox $d2ConfigLibDir $owner $D2PW $pkgPath"
	if [ $? -ne 0 ];then
		echo "[ERROR]Setting up the Lockbox Failed"
	exit -1
        else 

        	echo "[INFO]Setting up the Lockbox completed"
	exit 0
	fi
	
	exit 0
    fi
  
    
    
    
    getUserEnteredValues
    permChange
    verifyCellndeploy
    postConfiguration
    startupScripts
	 if [ $restartOps == "Apps" ] ; then

    startApps
	else

	    restartCluster
	fi
    exit 0	
else
  echo "[ERROR] InstanceType onType is \"$InstanceType \", please input a valid InstanceType such as \"install\""
   exit -1
fi
