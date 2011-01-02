require "nice_enum"
require "test/unit"

class AttributeTest < Test::Unit::TestCase
	class Number < Enum
		enum :Twenty, 20,
			:note => "Exact value of e^pi - pi"
		
		enum :Ninety, 90,
			:note => "Square Root of -1"
		
		enum :FourtyTwo, 42
	end
	
	def test_respond_to_known_attribute
		assert Number::Twenty.respond_to?(:note)
	end
	
	def test_get_attribute_from_known_value
		assert_equal "Exact value of e^pi - pi", Number::Twenty.note
	end
	
	def test_get_attribute_from_unknown_value
		assert_equal nil, Number.new(8).note
	end
	
	def test_respond_to_unknown_attribute
		assert !Number::Twenty.respond_to?(:color)
	end
end
