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

  opts.on("--db [ACTION]", [:migrate, :rollback, :generate], "executes migrations with 'migrate' or undoes very last migration with 'rollback', also executes 'generate' for new model") do |o|
    options[:migration] = o
  end

  opts.on("--help", "Shows this help") do |o|
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
elsif options[:migration] == :generate
  new_model_options = ARGV
  model_name = new_model_options.shift
  
  time_now = Time.now.strftime("%Y%m%d%M%S%L")
  File.open("./migrations/#{time_now}_create_#{model_name}.rb", 'w') do |file|
    file.write("class create_#{model_name.classify} < ActiveRecord::Migration\n")
    file.write("  def up\n")
    file.write("    create_table :#{model_name.pluralize} do |t|\n")

    new_model_options.each do |column|
      name, type = column.split(/\:/)
      file.write("      t.#{type} :#{name}\n")
    end
    file.write("\n      t.timestamps null: false\n")

    file.write("    end\n")
    file.write("  end\n")
    file.write("\n")
    file.write("  def down\n")
    file.write("    drop_table :#{model_name.pluralize}\n")
    file.write("  end\n")
    file.write("end")
  end

  File.open("./models/#{model_name}.rb", 'w') do |file|
    file.write("class #{model_name.classify} < ApplicationRecord\n")

    new_model_options.each do |column|
      name, type = column.split(/\:/)
      file.write("  #{type} :#{name}\n") if type == 'belongs_to'
    end

    file.write("end")
  end
end