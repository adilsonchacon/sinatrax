require './environment'
require './lib/migration'
require 'optparse'

def get_instance(file)
  require file
  klass_name = file.split(/\//).last.gsub(/^[0-9]+\_/, '')
  klass_name = klass_name.gsub(/\.rb$/, '')
  klass_name = klass_name.split(/\_/).map { |piece| piece.capitalize }.join('')
  klass = Object.const_get(klass_name)
  klass.new
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby schema.rb [options]"

  opts.on("-d", "--do [ACTION]", [:migrate, :rollback], "executes undone migrations with 'migrate' or undoes very last migration with 'rollback'") do |o|
    options[:migration] = o
  end

  opts.on("-h", "--help", "Shows this help") do |o|
    puts opts
    exit
  end
end.parse!

if options[:migration].nil? 
  p "Invalid action! Use 'migrate' to execute undone migration or 'rollback' to undo very last migration"
  exit
# migrations up
elsif options[:migration] == :migrate
  Dir["./migrations/*.rb"].sort.each do |file|
    version = file.split(/\//).last.split(/\_/).first
    schema_migration = SchemaMigration.where(version: version).first

    if schema_migration.nil?      
      class_instance = get_instance(file)      
      class_instance.up
      
      new_schema_migration = SchemaMigration.new
      new_schema_migration.version = version
      new_schema_migration.save
    end
  end
# migrations down
elsif options[:migration] == :rollback
  begin
    schema_migration = SchemaMigration.order('version').last
    if schema_migration.nil?
      p 'There is no rollback to execute'
      exit
    end

    file = Dir["./migrations/#{schema_migration.version}\_*.rb"].sort.last
    class_instance = get_instance(file)      
    class_instance.down
    
    schema_migration.destroy
  rescue Exception => e
    raise e
  end
end