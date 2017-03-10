# !/bin/sh
set -x

#path=$(cd "$(dirname "$0")"; pwd)
path=$6
export CLASSPATH=
export LD_LIBRARY_PATH=
log=$8
echo "log====>" $log

JARCMD=`ps -e -o cmd |grep java |grep dmgr |grep "$1" |cut -d " " -f 1 |head -c-5`"jar"
echo "JARCMD=====>" $JARCMD
rm -rf $path/$5
mkdir $path/$5

if [ -d $5 ]
 then
	cd $5
else
	 mkdir $5
 	cd $5
fi
appName=$5.war 
pwd
$JARCMD xf $2
sed -i -e 1d WEB-INF/classes/dfc.properties
echo  "dfc.docbroker.host[0]=$3" >>  WEB-INF/classes/dfc.properties
echo "dfc.docbroker.port[0]=1489" >> WEB-INF/classes/dfc.properties
echo  "dfc.docbroker.host[1]=$3" >>  WEB-INF/classes/dfc.properties
echo "dfc.docbroker.port[1]=1589" >> WEB-INF/classes/dfc.properties
echo  "dfc.docbroker.host[2]=$4" >>  WEB-INF/classes/dfc.properties
echo "dfc.docbroker.port[2]=1489" >> WEB-INF/classes/dfc.properties
echo  "dfc.docbroker.host[3]=$4" >>  WEB-INF/classes/dfc.properties
echo "dfc.docbroker.port[3]=1589" >> WEB-INF/classes/dfc.properties
echo "dfc.session.secure_connect_default=try_native_first" >>WEB-INF/classes/dfc.properties
echo "dfc.globalregistry.repository=globalstore" >> WEB-INF/classes/dfc.properties
echo "dfc.globalregistry.username=dm_bof_registry" >>WEB-INF/classes/dfc.properties
echo "dfc.globalregistry.password=Kp5SfLhhF6w\=" >> WEB-INF/classes/dfc.properties


                       echo "[INFO] Updating D2FS.properties &  D2-Config properties Files*********************"

if [ $5 == "D2" ]
then
#grep "<file>.*</file>" WEB-INF/classes/logback.xml | sed "s/<file>*.*<\/file>/<file>\/opt\/CITI_DCTMD2AppP19\/log\/D2.log<\/file>/g" WEB-INF/classes/logback.xml >> WEB-INF/classes/logback1.xml
#grep "<fileNamePattern>" WEB-INF/classes/logback1.xml | sed "s/<fileNamePattern>*.*<\/fileNamePattern>/<ileNamePattern>\/opt\/CITI_DCTMD2AppP19\/log\/D2-%d{yyyy-MM-dd}.log.zip<\/fileNamePattern>/g" WEB-INF/classes/logback1.xml >> WEB-INF/classes/logback2.xml

grep "<file>.*</file>" WEB-INF/classes/logback.xml | sed -i -e "s/<file>*.*<\/file>/<file>\/opt\/CITI_DCTMD2AppP19\/log\/D2.log<\/file>/g" WEB-INF/classes/logback.xml

grep "<fileNamePattern>" WEB-INF/classes/logback.xml | sed -i -e "s/<fileNamePattern>*.*<\/fileNamePattern>/<fileNamePattern>\/opt\/CITI_DCTMD2AppP19\/log\/D2-%d{yyyy-MM-dd}.log.zip<\/fileNamePattern>/g" WEB-INF/classes/logback.xml
#cp WEB-INF/classes/logback2.xml WEB-INF/classes/logback.xml
#rm -rf WEB-INF/classes/logback2.xml WEB-INF/classes/logback1.xml

sed -i "s|"#lockboxPath="|"lockboxPath=$7"|g" WEB-INF/classes/D2FS.properties
		if [ -f  WEB-INF/lib/wstx-lgpl-3.2.9.jar ]
		then 
			echo "File Exists"
		else
  			echo "File doesn't exist...." 
		
		fi

#if [ -f WEB-INF/lib/jsr173_api.jar ]
 #               then
  #                      echo "File Exists.Deleting it.."
#			rm -f WEB-INF/lib/jsr173_api.jar
#			echo "Deleted..."
 #               else
  #                      echo "jsr173_api.jar doesn't exist...."
#
 #               fi
#rm WEB-INF/lib/jsr173_api.jar
cp $path/citigroup_d2plugins.jar WEB-INF/lib
elif [ $5 == "D2-Config" ]
then 
#grep "<file>.*</file>" WEB-INF/classes/logback.xml | sed "s/<file>*.*<\/file>/<file>\/opt\/CITI_DCTMD2AppP19\/log\/D2-Config.log<\/file>/g" WEB-INF/classes/logback.xml >> WEB-INF/classes/logback1.xml
grep "<file>.*</file>" WEB-INF/classes/logback.xml | sed -i -e "s/<file>*.*<\/file>/<file>\/opt\/CITI_DCTMD2AppP19\/log\/D2-Config.log<\/file>/g" WEB-INF/classes/logback.xml

grep "<fileNamePattern>" WEB-INF/classes/logback.xml | sed -i -e "s/<fileNamePattern>*.*<\/fileNamePattern>/<fileNamePattern>\/opt\/CITI_DCTMD2AppP19\/log\/D2-Config%d{yyyy-MM-dd}.log.zip<\/fileNamePattern>/g" WEB-INF/classes/logback.xml

#cp WEB-INF/classes/logback1.xml WEB-INF/classes/logback.xml
				

sed -i "s|"#lockboxPath="|"lockboxPath=$7"|g" WEB-INF/classes/D2-Config.properties

else 
 echo " No file found"
fi
cp $path/shiro.ini WEB-INF/classes
                        
echo " done till here"
echo "$5====>" $5
$JARCMD cf $path/$appName .
if [[ "$?" -eq "0" && -f "$path/$appName" ]]
 then
  echo "File $path/$appName is re-created"
  exit 0
else 
  echo "Fail to re-create $appName file"
  exit 1
fi


