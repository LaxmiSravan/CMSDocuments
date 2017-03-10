#!/usr/bin/ksh
#
# This script should be run as WAS cluster owner without sourcing existing .profile
#    su $owner -c ....
#
set -x
WAS_HOME=`echo $1`
echo "1-->" $WAS_HOME
LOCKBOXHOME=`echo $2`
echo "2--->" $LOCKBOXHOME

D2ConfigLib=`echo $3`
echo "3--->" $D2ConfigLib
# FID is Not used currently
FID=`echo $4`
echo "4---->" $FID

D2PW=`echo $5`
pkgPath= `echo $6`
echo "5--->" $D2PW
# 

# LJ 3.19.16: overwrite existing ~/.D2APPENV.env
echo "export CLASSPATH=$D2ConfigLib/C6-Common-4.5.0.jar:$LOCKBOXHOME/lib/LB.jar:$LOCKBOXHOME/lib/LBJNI.jar:"'$CLASSPATH'> ~/.D2APPENV.env
echo "export LD_LIBRARY_PATH=$LOCKBOXHOME/native/linux_gcc34_x64:"'$LD_LIBRARY_PATH'>> ~/.D2APPENV.env
echo "export PATH=$LOCKBOXHOME:$LOCKBOXHOME/native/linux_gcc34_x64:"'$PATH'>> ~/.D2APPENV.env

echo . ./.D2APPENV.env >> ~/.profile

# LJ 3.19.16:setup env and run java SetLockboxProperty
. ~/.D2APPENV.env
echo "$WAS_HOME/WebSphere/85-64/java/bin/java com.emc.common.java.crypto.SetLockboxProperty $LOCKBOXHOME D2Method.passphrase $D2PW">>$pkgPath/scripts/setlockbox.README
#$WAS_HOME/WebSphere/85-64/java/bin/java com.emc.common.java.crypto.SetLockboxProperty $LOCKBOXHOME D2Method.passphrase Welcome1!
$WAS_HOME/WebSphere/85-64/java/bin/java com.emc.common.java.crypto.SetLockboxProperty $LOCKBOXHOME D2Method.passphrase $D2PW

