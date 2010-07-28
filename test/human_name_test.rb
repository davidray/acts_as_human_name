require 'test/unit'

require 'rubygems'
gem 'activerecord', '>= 1.15.4.7794'
require 'active_record'

require "#{File.dirname(__FILE__)}/../init"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :human do |t|
      t.column :last_name, :string
      t.column :first_name, :string
      t.column :middle_name, :string      
      t.column :suffix, :string
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Human < ActiveRecord::Base
end

class User < Human
  acts_as_human_name

  def self.table_name() "Human" end
end

require 'test_helper'

class UserTest < ActiveRecord::TestCase
  should "format the name normally" do
    user = User.new
    user.first_name = "Richard"
    user.middle_name = "Twerple"
    user.last_name = "Nugget"
    assert_equal user.name, "Richard Nugget"
    assert_equal user.regular_name, "Richard Nugget"
    assert_equal user.full_name, "Nugget, Richard Twerple"
    
    user.first_name = "Richard"
    user.middle_name = "Twerple"
    user.last_name = "Nugget"
    user.suffix = "III"
    assert_equal user.name, "Richard Nugget"
    assert_equal user.regular_name, "Richard Nugget"
    assert_equal user.full_name, "Nugget, Richard Twerple III"
    
    user.first_name = "Richard"
    user.last_name = "Nugget"
    user.middle_name = nil
    user.suffix = nil
    assert_equal user.name, "Richard Nugget"
    assert_equal user.regular_name, "Richard Nugget"
    assert_equal user.full_name, "Nugget, Richard"
    
    user.first_name = "Richard"
    user.last_name = "Twerple"
    user.suffix = "III"
    assert_equal user.name, "Richard Twerple"
    assert_equal user.regular_name, "Richard Twerple"
    assert_equal user.full_name, "Twerple, Richard III"
    
    user.first_name = nil
    user.suffix = nil
    user.last_name = "Nugget"
    assert_equal user.name, "Nugget"
    assert_equal user.regular_name, "Nugget"
    assert_equal user.full_name, "Nugget"
    
    user.first_name = "Richard"
    user.last_name = nil
    assert_equal user.name, "Richard"
    assert_equal user.regular_name, "Richard"
    assert_equal user.full_name, "Richard"
  end
end