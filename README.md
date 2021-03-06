# A social content creation tool with cartography features

## An idea

* A document consist of sections, sections contain paragraphs.

* One single paragraph may have many instances across different documents.
  Users can repost paragraphs, createdby someone else. When the original author updates the paragraph then that update propagates to all the instances.

* Similar, one section may simultaneously exists in different documents.
  Any changes in that section are visible in all that documents.

## Paragraph

* Markdown markup may be used.
* Youtube or Vimeo links turns into embedded video.
* A single image may be uploaded and linked to a single paragraph.
* A paragraph may contain geographic coordinates, in that case the map with a pointer on it is shown.

## User identity

* A user is forced to be anonymous, but with per-document identity.

## Technologies used

* Rails, PostgreSQL
* Slim, Sass, CoffeScript
* jQuery, Leaflet
* [Redcarpet](https://github.com/vmg/redcarpet) (Markdown processing library) extended for linking pages, sections and documents ([markdown_render.rb](app/helpers/markdown_render.rb))


## Install

### Mac OS X, step 1

Install PostgreSQL from http://postgresapp.com


### Ubuntu, step 1

Install PostgreSQL

    apt-get install postgresql postgresql-doc postgresql-server-dev-9.1

Install required packages for ruby and for gems

    apt-get install build-essential libreadline-dev libssl-dev zlib1g-dev libyaml-dev libxslt-dev libxml2-dev

Install image processing tools. Graphicsmagick packaged with ubuntu 12.04 version does not yet have 'strip' function, so using imagemagick

    sudo apt-get install imagemagick # graphicsmagick


### Step 2

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


## Copyright and License

Please see the [LICENSE](LICENSE) file.

For the list of dependencies please see the [Gemfile](Gemfile) file.
