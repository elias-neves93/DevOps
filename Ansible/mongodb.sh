#!/bin/bash

DB_HOST=
DB_PORT=
DB_USERNAME=
DB_PASSWORD=
MONGO=`which mongo`
JQ=`which jq`
EXIT_ERROR=1
EXIT_OK=0

if [ ! -x "$MONGO" ] ; then
  echo "mongo not found"
  exit $EXIT_ERROR
elif [ ! -x "$JQ" ] ; then
  echo "jq not found"
  exit $EXIT_ERROR
elif [ $# -eq 0 ] ; then
  echo "No values pass"
  exit $EXIT_ERROR
fi
index=.$(echo $@ | sed 's/[ ,]/./g')
MONGO_CMD="$MONGO --host ${DB_HOST:-localhost} --port ${DB_PORT:-27017} --authenticationDatabase admin --quiet"
[[ "$DB_USERNAME" ]] && MONGO_CMD="${MONGO_CMD} --username ${DB_USERNAME}"
[[ "$DB_PASSWORD" ]] && MONGO_CMD="${MONGO_CMD} --password ${DB_PASSWORD}"

output=$(
	$MONGO_CMD <<< "db.runCommand( { serverStatus: 1} )" |\
	sed -e 's/NumberLong(\(.*\))/\1/
	  s/ISODate(\(.*\))/\1/
	  s/ObjectId(\(.*\))/\1/
	  s/Timestamp(.*)/"&"/
	  s/"\([0-9]*\)"/\1/'
)

mongo_status=${PIPESTATUS[0]}
if [ $mongo_status -ne $EXIT_OK ] ; then
  echo "mongo exec error"
  exit $EXIT_ERROR
fi
value=$(echo $output | jq $index)
jq_status=$?
echo $value
