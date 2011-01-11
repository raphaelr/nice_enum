#--
# Copyright (c) 2010, Raphael Robatsch
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * The names of the developers or contributors must not be used to
#       endorse or promote products derived from this software without
#       specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE DEVELOPERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE DEVELOPERS OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#++

# Base class for all Enumerations. To create an Enumeration, subclass this
# class and add enum calls in the class body.
# There are many samples in README.rdoc and samples/ .
class Enum
	include Comparable
	
	# Returns the name of the enumeration member. This is the first parameter
	# passed to +enum+, converted to a string.
	attr_reader :name
	
	# Returns the value of the enumeration member. This is the second parameter
	# passed to +enum+.
	attr_reader :value
	
	# Compares the value of +self+ with the value of +other+.
	def <=>(other)
		other = other.value if other.is_a? self.class
		return value <=> other
	end
	
	# Returns the hashcode of +value+.
	def hash
		value.hash
	end
	
	# Returns the name of the enumeration member.
	def to_s
		@name
	end
	
	alias old_respond_to? respond_to? # :nodoc:
	def respond_to?(sym) # :nodoc:
		old_respond_to?(sym) || @value.respond_to?(sym)
	end
	
	def method_missing(sym, *args, &block) # :nodoc:
		@value.send(sym, *args, &block)
	end
	
	class << Enum
		include Enumerable
		
		# Returns the +Enum+ instance for the given value. If no enumeration
		# member has been created for this value, a new instance is created,
		# setting +name+ to +value.to_s+.
		def new(value)
			return @enumvalues[value] if @enumvalues.has_key? value
			_setup_enumvalue(value, value, allocate)
		end
		
		# Returns the default value for the attribute +attr+. If no default
		# value has been set, +nil+ is returned.
		def default_value(attr)
			@defaults ||= {}
			@defaults[attr.to_sym]
		end
		
		# Enumerates all known enumeration members.
		def each
			@enumvalues ||= {}
			@enumvalues.each_value { |enumvalue| yield enumvalue }
		end
		
		protected
		# Adds a new enumeration member to the current enumeration. The
		# generated member is accessible using the constant +name+. If
		# +value+ is +nil+, it is set to the highest integer value in
		# use \+ 1.
		def enum(name, value = nil, attributes = {})
			@enumvalues ||= {}
			value ||= (@enumvalues.values.max || -1) + 1
			
			enumvalue = allocate
			const_set(name, enumvalue)
			@enumvalues[value] = enumvalue
			_setup_enumvalue(name, value, enumvalue, attributes)
		end
		
		def _setup_enumvalue(name, value, enumvalue, attributes = {}) # :nodoc:
			enumvalue.instance_variable_set(:@name, name.to_s)
			enumvalue.instance_variable_set(:@value, value)
			attributes.each do |attribute, attr_value|
				_create_accessor(attribute)
				enumvalue.instance_variable_set("@#{attribute}", attr_value)
			end
			enumvalue
		end
		
		# Sets the default values for the attributes of the enumeration members.
		# There can be more than one call to +defaults+.
		def defaults(defs = {})
			@defaults ||= {}
			@defaults.merge!(defs)
		end
		alias default defaults
		
		def _create_accessor(attribute) # :nodoc:
			define_method(attribute) do
				instance_variable_get("@#{attribute}") || self.class.default_value(attribute)
			end
		end
	end
end

# Base class for enumerations in which members can be or'd together to create
# combinations of them. For example, Unix file permissions can be represented
# as a flag enumeration with the members <tt>Read = 4</tt>, <tt>Write = 2</tt>
# and <tt>Execute = 1</tt>. There are many samples in README.rdoc and samples/.
class Flags < Enum
	# Returns the individual enumeration members that are contained in +self+.
	# If the enumeration class contains a member with the value +0+, that
	# member is only included in the result if there aren't any other members
	# that are contained in +self+.
	def flags
		result = self.class.select { |flag| value & flag != 0 }.sort
		result = [self.class.new(0)] if result.empty?
		result
	end
	
	# Joins the result of +flags+ together.
	def join(seperator = " | ")
		flags.map { |flag| flag.name }.join(seperator)
	end
	alias to_s join
	
	# Returns the combination of +self+ and +other+.
	def |(other)
		self.class.new(value | other)
	end
	
	# Returns the intersection of +self+ and +other+.
	def &(other)
		self.class.new(value & other)
	end
	
	# Bitwise-XORs +self+ with +other+.
	def ^(other)
		self.class.new(value ^ other)
	end
end
