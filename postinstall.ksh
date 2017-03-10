#! /usr/bin/ksh

#ident  "@(#)Product:CITI_DCTMD2App Release:1.0_A1 Component:src File:postinstall.ksh 11"

# *************************************************************************
# **
# **************************************************************************


# Laxmi Molgara 07/22/2012

if [[ $# == 1 ]]
then
	 ADMINID=$1
else
	echo "USAGE: $0 FunctionID"
	echo "example: $0 dmadmin"
	exit -1
fi

APP_HOME=`dirname $0`

MACHINENAME=`uname -n`
MYTODAY=`date +"%Y%m%d%s"`

CFG_FILE=$APP_HOME/../cfg/`basename $0|sed s/ksh/cfg/`
. $CFG_FILE

GROUPID=`id -ng $ADMINID`
echo "LOGDIR--------->" $LOGDIR
if [[ ! -d ${LOGDIR} ]]
then
        mkdir ${LOGDIR}
fi
chown -R $ADMINID:$GROUPID ${LOGDIR}

chown -R $ADMINID:$GROUPID /opt/$PKGNAME/
chmod -R 755 /opt/$PKGNAME/scripts
chmod -R 744 /opt/$PKGNAME/cfg
chmod -R 755 /opt/$PKGNAME/d245





