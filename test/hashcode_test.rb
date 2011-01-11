require "nice_enum"
require "test/unit"

class HashcodeTest < Test::Unit::TestCase
	VALUE = 18505
	HASH = VALUE.hash
	
	class Enumeration < Enum
		enum :Value, VALUE
	end
	
	def test_hashcode_is_underlying_hash
		assert_equal HASH, Enumeration::Value.hash
	end
	
	def test_hashcode_from_constructor
		value = Enumeration.new(VALUE)
		assert_equal HASH, value.hash
	end
end
