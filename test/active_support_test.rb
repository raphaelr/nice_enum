require 'rubygems'
gem 'activerecord'
require 'active_record'
require "nice_enum"
require "nice_enum_active_record_extension"
require "test/unit"

ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :database => ':memory:'

silence_stream(STDOUT) do
  ActiveRecord::Schema.define do
    create_table :my_models do |t|
      t.string :my_number
    end
  end
end

class ActiveSupportTest < Test::Unit::TestCase

  ActiveRecord::Base.send :include, NiceEnumActiveRecordExtension

  class Number < Enum
    enum :One
    enum :Two
  end

  class MyModel < ActiveRecord::Base

    attr_accessible :my_number

    map_enum :my_number, Number
  end

  def test_respond_to_known_attribute
    model = MyModel.new
    model.my_number = Number::Two
    assert model.my_number == Number::Two
  end
end