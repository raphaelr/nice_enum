require "nice_enum"
require "test/unit"

class DefaultAttributeTest < Test::Unit::TestCase
	class Number < Enum
		default :note => "A boring number"
		
		enum :Twenty, 20,
			:note => "Exact value of e^pi - pi"
		
		enum :Ninety, 90,
			:note => "Square Root of -1"
		
		enum :FourtyTwo, 42
	end
	
	def test_get_set_attribute
		assert_equal "Exact value of e^pi - pi", Number::Twenty.note
	end
	
	def test_get_unset_attribute
		assert_equal "A boring number", Number::FourtyTwo.note
	end
end
