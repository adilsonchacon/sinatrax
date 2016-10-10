# MYSQL OR POSTGRE
ActiveRecord::Base.establish_connection(YAML::load_file('./config/database.yml'))

# SQLITE 3
# set :database, 'sqlite3:db/sqlite.db'
# set :show_exceptions, true