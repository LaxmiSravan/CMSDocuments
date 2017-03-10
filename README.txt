#ident  "%W%"

===========================================================================================================================

This release note will provide instructions of how to install CITI_DCTMD2App package. 
The system administrator is responsible for installing the package on the machine. 

1. Install CITI_DCTMD2App package by downloading from GDS.

2. Execute ksh -x <CITI_DCTMD2App pkg home>/scripts/postinstall.ksh <pkg version> <$ADMINID>
postinstall.ksh will change ownership of package to $ADMINID. Postinstall will also give required permissions to scripts and create symlinks.

NOTE: $ADMINID is an account with admin access and it is sourced from $DOCUMENTUM/../.profile. Default values for $ADMINID and $GROUPID are dmadmin and dmadmin.
 
===========================================================================================================================

===========================================================================================================================



1. Navigate to scripts folder and run the following script
	./productMain.sh ./productMain.param as root
   NOTE: Change the permissions accrodingly, if not able to execute the command
2. productMain.param file will have all ther equired parameters to be passed to the script to install the D2/D2-Config
   Change the below parameter values according to your environment.
	************************************************************************
	Params description:
	************************************************************************
     	
	RuntimeLoc: is the run time location of the WAS instance where you have was runtime.
	AppName: is the name of the was instance.
	Version: will be the WAS version. for D2/D2-Config the compatible version is 8554. So no need to change this in the param file.
       Environment: Need not be changed
	ContentServer1: The name of the machine where your contentserver is installed.
	ContentServer2: The name of the second instance where the CS is installaed for the D2 Apps.
	
 	************************************************************************************
	RuntimeLoc=/opt/middleware
	AppName=d2test
	Version=8554
	Environment=DEV
	ContentServer1=vm-ffe0-85ab.nam.nsroot.net
	ContentServer2=vm-ffe0-85ab.nam.nsroot.net

3.  structure related to D2
    /opt/CITI_DCTMD2App
    /opt/CITI_DCTMD2App/d245/Lockbox

4. D2App logs:
   /tmp/D2.log for D2
   /tmp/d2-Config.log for D2-Config

5. D2Apps cache 
    /tmp/d2app

6. App Server Log location:
   Eg:If d2test is the app server name: then the Log location is
   /opt/middleware/d2test/d2test_Runtime/profiles/d2testCell/d2testProfile/logs/d2testServer/SystemOut.log
  /opt/middleware/d2test/d2test_Runtime/profiles/d2testCell/d2testProfile/logs/ffdc
  /opt/middleware/d2test/d2test_Runtime/profiles/d2testCell/d2testProfile/logs/nodeagent

7.D2-Config App config files locations
   /opt/middleware/d2test/d2test_Runtime/profiles/d2testCell/d2testProfile/installedApps/d2testCell/D2-Config.ear/D2-Config.war/WEB-INF/classes/dfc.properties
   /opt/middleware/d2test/d2test_Runtime/profiles/d2testCell/d2testProfile/installedApps/d2testCell/D2-Config.ear/D2-Config.war/WEB-INF/logback.xml
   /opt/middleware/d2test/d2test_Runtime/profiles/d2testCell/d2testProfile/installedApps/d2testCell/D2-Config.ear/D2-Config.war/WEB-INF/D2-Config.properties

8. D2 App config file Locations:
    /opt/middleware/d2test/d2test_Runtime/profiles/d2testCell/d2testProfile/installedApps/d2testCell/D2.ear/D2.war/WEB-INF/classes/dfc.properties
    /opt/middleware/d2test/d2test_Runtime/profiles/d2testCell/d2testProfile/installedApps/d2testCell/D2.ear/D2.war/WEB-INF/classes/logback.xml
    /opt/middleware/d2test/d2test_Runtime/profiles/d2testCell/d2testProfile/installedApps/d2testCell/D2.ear/D2.war/WEB-INF/classes/D2FS.properties


9. Lockbox path
   /opt/CITI_DCTMD2App/d245/Lockbox


