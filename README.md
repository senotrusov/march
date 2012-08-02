About
=====
Here be dragons


Install
=======
I'm using Ubuntu 12.04 for development, hope it will run under your environment.

You need to install ruby 1.9 and postgresql first.


    # graphicsmagick packaged with ubuntu 12.04 version does not yet have 'strip' function, so using imagemagick
    sudo apt-get install graphicsmagick
    sudo apt-get install imagemagick

    # Create db user and store the password in ~/.pgpass
    # thus you don't need to specify the password in config/database.yml
    script/create-db-user

    # Drop database if exists then create new database with structure
    script/recreate-db

    # Install gems
    bundle install

    # run
    rails s


Licence
=======
Apache License, Version 2.0, see LICENSE file.


3rd party code
==============
1. Gemfile
  * Font Awesome - http://fortawesome.github.com/Font-Awesome, licensed under CC BY 3.0
2. Leaflet in vendor/assets (see vendor/assets/Leaflet-LICENCE)


Documentation
=============
* Rails Guides: http://guides.rubyonrails.org
* Rails API: http://api.rubyonrails.org
* Ruby core: http://www.ruby-doc.org/core
* Ruby standard library: http://www.ruby-doc.org/stdlib

* HTML5 differences from HTML4: http://www.w3.org/TR/html5-diff
