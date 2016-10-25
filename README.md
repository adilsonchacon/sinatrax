# What's Sinatrax for?
Use Sinatrax to create Sinatra projects with ActiveRecord, Migration, Bootstrap and FontAwesome in a fast way

# How to use it?
    git clone https://github.com/adilsonchacon/sinatrax.git
    cd sinatrax/
    bundle install
    rackup config.ru

# How it works?
Sinatrax has support for ActiveRecord and Migration.

You can generate yours models, just like that:

    schema --db generate author name:string age:integer
    schema --db generate post title:string body:text author:belongs_to

Check the migrations and models directories.

Execute your migrations:

    schema --db migrate

Or rollback:

    schema --db rollback