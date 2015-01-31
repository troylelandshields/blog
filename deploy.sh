HOST='shldz.us'
USER='troyblog1'
PASSWD='Snoopy!0015'

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
mdelete -R *
mput -R ./public/*
quit
END_SCRIPT
exit 0
