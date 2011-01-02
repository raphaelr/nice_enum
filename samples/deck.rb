require "../lib/nice_enum"

module Cards
	class Suit < Enum
		enum :Spades
		enum :Hearts
		enum :Diamonds
		enum :Clubs
	end
	
	class Value < Enum
		enum :Ace,    1,    :score => 11 # For the sake of simplicity
		enum :Two,    2,    :score => 2
		enum :Three,  3,    :score => 3
		enum :Four,   nil,  :score => 4
		enum :Five,   nil,  :score => 5
		enum :Six,    nil,  :score => 6
		enum :Jack,   nil,  :score => 10
		enum :Queen,  nil,  :score => 10
		enum :Knight, nil,  :score => 10
	end
	
	class Card
		attr_accessor :suit
		attr_accessor :value
		
		def initialize(suit, value)
			@suit = suit
			@value = value
		end
		
		def to_s
			"#{value} of #{suit}"
		end
	end
	
	class Deck
		def initialize
			@cards = Suit.map do |suit|
				Value.map do |value|
					Card.new(suit, value)
				end
			end.flatten.shuffle
		end
		
		def draw(n)
			@cards.slice!(0, n)
		end
	end
end

deck = Cards::Deck.new
hand = deck.draw(5)

puts "Your hand:"
hand.each do |card|
	puts " - #{card}"
end
puts "Blackjack score: #{hand.inject(0) { |score, card| score + card.value.score }}"
