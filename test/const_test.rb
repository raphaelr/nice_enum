require "nice_enum"
require "test/unit"

class ConstTest < Test::Unit::TestCase
	class Number < Enum
		enum :Zero, 0
		enum :One, 1
		enum :Two, 2
	end
	
	def test_to_s
		assert_equal "Zero", Number::Zero.to_s
	end
	
	def test_value_equality
		assert_equal 2, Number::Two.value
	end
	
	def test_enum_equality
		assert_equal Number::Zero, Number::Zero
	end
	
	def test_mixed_equality
		assert_equal Number::Zero, 0
	end
	
	def test_new_stays_same
		assert_same Number::Zero, Number.new(0)
	end
	
	def test_new_on_undefined_enum_value
		assert_equal -13, Number.new(-13)
		assert_equal "-13", Number.new(-13).to_s
	end
	
	def test_respond_to_mirroring
		assert Number::One.respond_to? :abs
	end
	
	def test_send_mirroring
		assert_equal -1, -Number::One
	end
	
	def test_enumerable
		assert_equal [Number::Zero, Number::One, Number::Two], Number.to_a
	end
end
