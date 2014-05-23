require './lib/collections'
require 'database_cleaner'
require 'pry'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3", 
  :database => "./tmp/collection_test.sqlite3"
)

load File.dirname(__FILE__) + '/support/schema.rb'
load File.dirname(__FILE__) + '/support/models.rb'
