require "../lib/nice_enum"

class Permission < Flags
	enum :None, 0
	enum :Read, 4
	enum :Write, 2
	enum :Execute, 1
end

file = ARGV[0] || __FILE__
puts "Permissions on #{file}:"

mode = File.stat(file).mode
user = Permission.new((mode & 448) >> 6)
group = Permission.new((mode & 56) >> 3)
world = Permission.new(mode & 7)

puts "User:  #{user}"
puts "Group: #{group}"
puts "World: #{world}"
