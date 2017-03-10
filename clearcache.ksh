nodepath=`echo $1`
pkppath=`echo $2`
rm -rf $nodepath/documentum/apptoken
rm -rf $nodepath/documentum/cache

rm -rf $nodepath/documentum/checkout
rm -rf $nodepath/documentum/export
rm -rf $nodepath/documentum/local
rm -rf $nodepath/documentum/logs
rm -rf $nodepath/documentum/identityInterprocessMutex.lock
rm -rf $nodepath/wstemp/*
rm -rf $nodepath/temp/*
cd $pkgPath/d2app; rm -rf *cache.data; rm -rf xml-cache.index; 
rm -rf $pkgPath/d2app/*
