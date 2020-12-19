create extension "uuid-ossp";
create extension "pgcrypto"; 
create database gvmd;
GRANT ALL PRIVILEGES ON DATABASE "gvmd" to root;
CREATE ROLE dba with superuser noinherit;
grant dba to root;
ALTER ROLE root LOGIN;
