require "../lib/nice_enum"

class Number < Enum
	enum :Zero, 0
	enum :One, 1
	enum :Two, 2
	
	def square
		value ** 2
	end
end

numbers = Number.to_a
numbers << Number.new(3)

numbers.each { |number| puts "#{number} squared is #{number.square}." }
