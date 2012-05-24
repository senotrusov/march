#!/bin/sh -ex

#  Copyright 2012 Stanislav Senotrusov <stan@senotrusov.com>
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.


# Names
user=march
dbname=march
host=localhost
pgpass=~/.pgpass


# User interface helpers
# I use heredoc to avoid double printing the message with sh -x
# Unfortunately, the indentation in heredoc is somewhat out of place, so I'm a little aggravated the situation
# and got rid of the padding at all.
#
say(){
cat <<EOT
$1
EOT
}

confirm() {
cat <<EOT
$1

Enter 'y' to confirm that action, other input will abort the script execution
EOT

read confirmation
if
test "$confirmation" != "y"
then
exit
fi
}


# Define shortcuts for database connection
db="psql $dbname --host=$host --username $user --echo-all --set ON_ERROR_STOP=on"
postgres="sudo -u postgres -i psql postgres --username postgres --set ON_ERROR_STOP=on"


# Create user and allow it local access to database
if [ "`$postgres -c "SELECT 1 WHERE EXISTS(SELECT * FROM pg_catalog.pg_user WHERE usename = '$user')" --tuples-only --no-align`" != 1 ] ; then

  confirm "This script is about to add user '$user' to database, store user password as plain text in file $pgpass and chmod it to 06000"
  
  say "Please specify password for user $user:"
  read password

  
  $postgres -c "CREATE USER $user WITH PASSWORD '$password'"

  echo "$host:5432:$dbname:$user:$password" >> $pgpass
  chmod 0600 $pgpass
fi


# Drop and recreate database
confirm "This script is about to delete database $dbname and recreate it"

$postgres -c "DROP DATABASE IF EXISTS $dbname"
$postgres -c "CREATE DATABASE $dbname OWNER $user ENCODING 'UTF8'"

$db < db/structure-prototype.sql
$db < db/seeds-prototype.sql


# Dump schema to db/structure.sql
pg_dump $dbname --username $user --host=$host --schema-only > db/structure.sql
