About
=====

Open source knowledge base with cartography features.


### The idea

* A document consist of sections, sections contain paragraphs.

* One single paragraph may have many instances across different documents.
  A kind of repost or retweet, with the difference that when the original author updates the paragraph that update 
  propagates to all the instances.

* Similar, one section may simultaneously exists in different documents.
  Any changes in that section are visible in all that documents.

### Paragraph

* Markdown markup may be used.
* Youtube or Vimeo links turns into embedded video.
* A single image may be uploaded and linked to a single paragraph.
* A paragraph may contain geographic coordinates, in that case the map with a pointer on it is shown.

### User identity

* A user are forced to be anonymous, but with per-document identity.


### What does it look like?

There is one deployment of this code with some nice documents to look at:

* http://vokrug.org/sr/20
* http://vokrug.org/sr/15


### Technologies used

* Rails, PostgreSQL
* Slim, Sass, CoffeScript
* jQuery, Leaflet
* Markdown with extension for linking pages, sections and documents ([markdown_render.rb](https://github.com/senotrusov/march/blob/master/app/helpers/markdown_render.rb))

Install
=======

Mac OS X, step 1
----------------
Install PostgreSQL from http://postgresapp.com


Ubuntu, step 1
--------------
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
Apache License, Version 2.0, see LICENSE file for details.


3rd party code
==============
* Listed in [Gemfile](https://github.com/senotrusov/march/blob/master/Gemfile)
* Font Awesome - http://fortawesome.github.com/Font-Awesome, licensed under CC BY 3.0
* Leaflet - http://leaflet.cloudmade.com/, see [vendor/assets/Leaflet-LICENCE](https://github.com/senotrusov/march/blob/master/vendor/assets/Leaflet-LICENCE)
