#ident	"%W%" 
import sys

warpath=sys.argv[0]
clusterName=sys.argv[1]
contextName=sys.argv[2]
appName=sys.argv[3]
######## replace the below with the above dynamic values"#########
AdminApp.options()

AdminApp.install(warpath, '[-cluster '+clusterName+'  -contextroot '+contextName+'  -appname '+appName+'  -defaultbinding.virtual.host default_host -usedefaultbindings  -nopreCompileJSPs ]')

AdminConfig.save()

#$AdminApp options

#$AdminApp install "/opt/CITI_DCTMD2App/d245/war/D2-Config.war"  {-cluster ecmcloudCluster -contextroot /D2-Config -appname D2-Config -defaultbinding.virtual.host default_host -usedefaultbindings  -nopreCompileJSPs }
#$AdminApp install "/opt/CITI_DCTMD2App/d245/war/D2.war"  {-cluster ecmcloudCluster -contextroot /D2 -appname D2 -defaultbinding.virtual.host default_host -usedefaultbindings  -nopreCompileJSPs }

#$AdminConfig save
