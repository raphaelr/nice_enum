require "test/unit"
require "nice_enum"

class FlagsTest < Test::Unit::TestCase
	class Permission < Flags
		enum :Read, 4
		enum :Write, 2
		enum :Execute, 1
	end
	
	def test_binary_operators_return_class
		assert (Permission::Read | Permission::Write).is_a? Permission
	end
	
	def test_or
		assert_equal 6, Permission::Read | Permission::Write
	end
	
	def test_and
		assert_equal Permission::Write, 7 & Permission::Write
	end
	
	def test_xor
		assert_equal Permission::Read | Permission::Write, 7 ^ Permission::Execute
	end
	
	def test_single_flag
		assert_equal [Permission::Read], Permission::Read.flags
	end
	
	def test_multi_flags
		assert_equal [Permission::Write, Permission::Read], Permission.new(6).flags
	end
	
	def test_to_s
		assert_equal "Execute|Write", Permission.new(3).to_s.gsub(' ', '')
	end
end
