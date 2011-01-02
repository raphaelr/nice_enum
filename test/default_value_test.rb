require "test/unit"
require "nice_enum"

class DefaultValueTest < Test::Unit::TestCase
	class Suit < Enum
		enum :Spades
		enum :Hearts
		enum :Green, 48
		enum :Diamonds
		enum :Clubs
	end
	
	def test_enum_order
		assert_equal [Suit::Spades, Suit::Hearts, Suit::Green, Suit::Diamonds, Suit::Clubs], Suit.to_a.sort
	end
	
	def test_values
		assert_equal 1, Suit::Hearts.value
		assert_equal 48, Suit::Green.value
		assert_equal 49, Suit::Diamonds.value
	end
end
