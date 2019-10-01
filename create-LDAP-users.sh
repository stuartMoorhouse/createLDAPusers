#!/usr/bin/env bash

USERLIST=$1
DIRECTORY=$2

USERCOUNT=$(wc -l < $USERLIST)

if [ ! -d LDIFs ]; then
 mkdir LDIFs
fi

create_LDIF () {
	DIRECTORY=$1
	USER=$2
	DIRECTORY_ARRAY=(${DIRECTORY//./ })
	TOPLEVEL=${DIRECTORY_ARRAY[0]}
    DC_NEW_DELIM=$(sed  's/\./,DC=/g' <<< $DIRECTORY)
    DCS=DC=$DC_NEW_DELIM
    DATA="dn: CN=$USER,OU=Users,OU=$TOPLEVEL,$DCS \n\
objectClass: user \n\
sn: $USER \n\
sAMAccountName: $USER"
    FILENAME=$USER.ldif

    echo "  writing '$FILENAME'"
    echo -e $DATA > LDIFs/$FILENAME
    
}

while read USER; do
  create_LDIF  $DIRECTORY $USER
done <$USERLIST

echo $USERCOUNT LDIF files were written to /LDIFs

