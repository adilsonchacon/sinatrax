# What's Sinatrax for?
Use Sinatrax to create Sinatra projects with ActiveRecord, Migration, JQuery, Bootstrap and FontAwesome in a fast way. Also, Sinatrax is great to build microservices.

# How to use it?
    git clone https://github.com/adilsonchacon/sinatrax.git
    cd sinatrax/

Configure your database adapter just uncommeting the right _gem_ on _Gemfile_: mysql, postgres or sqlite3.

    gem 'mysql2'
    # gem 'pg'
    # gem 'sqlite3'

After that, set up database connection with the right adapter and credentials:

    cp config/database.yml.example config/database.yml

and edit _config/database.yml_:

    adapter:  "mysql2"
    host:     "localhost"
    username: "root"
    password: "aidentro!"
    database: "sinatrax"
    encoding: 'utf8'

Almost there! Just run:

    bundle install
    rackup config.ru

Done! You're ready to go!

# How it works?
Sinatrax has support for ActiveRecord and Migration.

You can generate yours models, just like that:

    ruby schema.rb --db generate author name:string age:integer
    ruby schema.rb --db generate post title:string body:text author:belongs_to

_(Please, check the "migration" and "model" directories.)_

Execute your migrations:

    ruby schema.rb --db migrate

Or rollback:

    ruby schema.rb --db rollback

# IRB

    irb
    require './environment'

# And More

* Sinatrax supports sessions
* Create your routes and views in the Sinatra way
* JQuery, Bootstrap and FontAwesome, all included
* Rackup allows you to deploy your application with _puma_, _unicorn_, _thin_ etc
* Use any gem you want
* Use any Javascript code and/or CSS you want
* ...

Just use your creativity and go further