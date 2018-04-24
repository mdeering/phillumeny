# frozen_string_literal: true

require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
  adapter:  'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do

  drop_table :posts if ActiveRecord::Base.connection.table_exists? :posts

  create_table :posts do |table|
    table.string  :title,                    default: nil,       allow_null: false, limit: 128
    table.boolean :include_in_sitemap,       default: true,      allow_null: false
    table.integer :sitemap_priorty,          default: 5,         allow_null: false
    table.string  :sitemap_change_frequency, default: 'monthly', allow_null: false
  end

end

class Post < ActiveRecord::Base
end
