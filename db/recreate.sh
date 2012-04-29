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


user=march
dbname=march

pgpass=~/.pgpass


db="psql $dbname --host=localhost --username $user --echo-all --set ON_ERROR_STOP=on"
postgres="sudo -u postgres -i psql postgres --username postgres --set ON_ERROR_STOP=on"

# Create user and allow it local access to database

if [ "`$postgres -c "SELECT 1 WHERE EXISTS(SELECT * FROM pg_catalog.pg_user WHERE usename = '$user')" --tuples-only --no-align`" != 1 ] ; then
  echo "Please specify password for user $user"
  read password
  $postgres -c "CREATE USER $user WITH PASSWORD '$password'"
  
  echo "WARNING! About to add password to $pgpass! Press RETURN to confirm that action."
  read confirmation
  echo "localhost:5432:$user:$dbname:$password" >> $pgpass
fi


# Drop and recreate database

$postgres -c "DROP DATABASE IF EXISTS $dbname"
$postgres -c "CREATE DATABASE $dbname OWNER $user ENCODING 'UTF8'"

# PostgreSQL 9 has plpgsql already
# $db -c "CREATE PROCEDURAL LANGUAGE plpgsql;"
# $db -c "ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO $user;"

# $db < /usr/share/postgresql/8.4/contrib/hstore.sql

$db < db/structure-prototype.sql
$db < db/seeds-prototype.sql

pg_dump $dbname --username $user --host=localhost --schema-only > db/structure.sql
