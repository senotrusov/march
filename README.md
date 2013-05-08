About
=====
Here be dragons


Install
=======

Step 1a (on Mac OS X)
---------------------
Install PostgreSQL from http://postgresapp.com


Step 1b (on Ubuntu)
-------------------
Install PostgreSQL

    apt-get install postgresql postgresql-doc postgresql-server-dev-9.1

Install required packages for ruby and for gems

    apt-get install build-essential libreadline-dev libssl-dev zlib1g-dev libyaml-dev libxslt-dev libxml2-dev

Install image processing tools. Graphicsmagick packaged with ubuntu 12.04 version does not yet have 'strip' function, so using imagemagick

    sudo apt-get install imagemagick # graphicsmagick


Step 2
------

Install rbenv from https://github.com/sstephenson/rbenv/

Create db user and store the password in ~/.pgpass
thus you don't need to specify the password in config/database.yml

    script/create-db-user

Drop database if exists then create new database with structure

    script/recreate-db

Install gems

    bundle install

run

    bundle exec rails s


Licence
=======
Apache License, Version 2.0, see LICENSE file.


3rd party code
==============
* See Gemfile for list
  * Font Awesome - http://fortawesome.github.com/Font-Awesome, licensed under CC BY 3.0
* Leaflet in vendor/assets - http://leaflet.cloudmade.com/, see vendor/assets/Leaflet-LICENCE


Documentation
=============
* Rails Guides: http://guides.rubyonrails.org
* Rails API: http://api.rubyonrails.org
* Ruby core: http://www.ruby-doc.org/core
* Ruby standard library: http://www.ruby-doc.org/stdlib

* HTML5 differences from HTML4: http://www.w3.org/TR/html5-diff
