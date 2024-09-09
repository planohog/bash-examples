#!/bin/bash
export PATH=/usr/bin:/bin:/usr/sbin:/sbin
USERNAME="mortaluser"
#FULLNAME="Mortal User"
if [[ -d "/Users/${USERNAME}" ]];
 then
 mv "/Users/${USERNAME}" "/Users/${USERNAME}.DELETED"
 rm -f "/Users/${USERNAME}"
fi
sysadminctl -deleteUser "${USERNAME}"
#sysadminctl -addUser "${USERNAME}" -fullName "${FULLNAME}" -password "${PASSWORD}" -hint "${PASSWORDHINT}"
