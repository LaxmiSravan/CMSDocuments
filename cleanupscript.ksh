cellPath=$1
fid=$2
WASLIB=$3
pkpPath=$4

rm -rf $pkgPath/d2app/*
#rm -rf $cellpath/*.xsd
mv /home/$fid/.D2APPENV.env /home/$fid/.D2APPENV.env.old
rm -rf $WASLIB/LB.jar $WASLIB/LBJNI.jar

