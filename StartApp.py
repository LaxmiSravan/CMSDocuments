#ident    "%W%"

"""
The script will let you deploy an Application
The arguments for the script are
1. The Name of the Application
2. The name of Server
3. The name of Node
4. The name of Cell
"""
appName = sys.argv[0]
serverName = sys.argv[1]
nodeName = sys.argv[2]
cellName = sys.argv[3]

appAlreadyStarted = "false"
appObjectName = AdminControl.completeObjectName('type=Application,name=' + appName + ',*')
print "==============================="
print AdminApp.getDeployStatus(appName)
print "==============================="
if str(appObjectName).strip() != '':
    appAlreadyStarted = "true"
    print 'The application ' + appName + ' is already started on ' + serverName + '.'
elif AdminApp.isAppReady(appName) == "false":
    print 'The application ' + appName + ' can not be started. It is not ready.'
else :
    appManager = AdminControl.queryNames('type=ApplicationManager,cell=' + cellName + ',node=' + nodeName + ',process='+ serverName +',*')
    print appManager
    AdminControl.invoke(appManager,  'startApplication', '[' + appName + ']', '[java.lang.String]')
