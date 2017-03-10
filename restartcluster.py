import sys
import time
arg1=sys.argv[0]
arg2=sys.argv[1]
print "in startnstopcluster............."
AdminControl.completeObjectName('cell='+arg2+',type=ClusterMgr,*')
#cluster = AdminControl.completeObjectName('cell=clouduatCell,type=Cluster,name=clouduatCluster,*')
cluster = AdminControl.completeObjectName('cell='+arg2+',type=Cluster,name='+arg1+',*')
print cluster
AdminControl.invoke(cluster, 'stop')
time.sleep(60)
print "cluster stopped==============>>>"
AdminControl.invoke(cluster, 'start')
print "cluster starting...................."
time.sleep(60)
print "cluster started...................."
