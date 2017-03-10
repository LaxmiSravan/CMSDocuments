import sys
profileName = sys.argv[0]
emtWasHome = sys.argv[1]
emtCoreHome = sys.argv[2]
serverName = sys.argv[3]
tmpDir = sys.argv[4]
emtWasHome=str(java.lang.System.getenv("EMT_WAS_HOME"))
emtCoreHome=str(java.lang.System.getenv("EMT_CORE_HOME"))
jvmargs = " -Demt.was.appname=" + profileName \
    + " -Demt.was.debug=false -Demt.was.home=" + emtWasHome \
    + " -Demt.core.home=" + emtCoreHome \
    + " -Dcom.ibm.websphere.security.util.createBackup=false" \
    + " -Dcom.ibm.wsspi.security.crypto.customPasswordEncryptionClass=com.citi.emt.was.security.CustomEncryptionImpl" \
    + " -Dcom.ibm.wsspi.security.crypto.customPasswordEncryptionEnabled=true" \
    + " -Demt.was.servername=" + serverName \
    + " -Djava.io.tmpdir=" + tmpDir 
#jvmargs = "-Djava.io.tmpdir=" + tmpDir 
svrId = AdminConfig.getid('/Server:' + serverName + '/')
print svrId
svrJvm = AdminConfig.list('JavaVirtualMachine', svrId)
print svrJvm
AdminConfig.modify(svrJvm,[['genericJvmArguments', jvmargs]])
AdminConfig.save()
