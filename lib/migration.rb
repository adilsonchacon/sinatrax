# creates migration for schema_migrations
class CreateSchemaMigration < ActiveRecord::Migration
  def up
    create_table :schema_migrations, id: false do |t|
      t.string :version, primary_key: true
    end
  end

  def down
    drop_table :schema_migrations
  end
end

# create table schema_migrations from migration
begin
  CreateSchemaMigration.new.up
rescue Exception => e
end

# class declaration for schema_migrations model
class SchemaMigration < ActiveRecord::Base
  self.primary_key = 'version'
end