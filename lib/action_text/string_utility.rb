#encoding: utf-8

# This module provides a bunch of methods which are useful for strings even outside the
# ActionText objects, so they're included as a Class Extension Mixin into the ActionText
# class.
# 
# Most important is the validation functionality, which can validate many stringtypes of
# everyday work. Each type has also it's specialized validator convenience method. The core
# method is <code>validate</code>, and every type has a special validation method that delegates to 
# <code>validate</code>. For example, when you want to check if a string is a valid email adress, 
# you can use either <code>validate 'MyEmail@example.com', :email</code> OR you can use
# the method <code>validate_email 'MyEmail@example.com'</code>.
#
# The current list of types is: 
# - :email
# - :url
module StringUtility

	@@patterns = {
		email: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i,
		url: /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix
	}

	# This useful methods removes ALL html-tags from the given string and returns the clean new string.
	def remove_html_tags str=nil
		str.gsub(/<\/?[^>]*>/, '')
	end

	# the core validation method. It takes the String you want to validate and the type of validation
	# you want to check against. Sample usage: <code>validate 'MyEmail@example.com', :email</code>. 
	# For a complete list of possible types, see the module description.
	def validate str, type
		return false unless @@patterns.has_key? type.to_sym
		str =~ @@patterns[type.to_sym] ? true : false
	end

private
		# create special validator methods for every pattern dynamically.
	# for example 
	# - <code>validate_email 'MyEmail@example.com' # => true </code>
	# - <code>validate_url 'http://example.com' # => true </code>
	def self.convenience_validators
		@@patterns.each { |type, pattern|
		method_name = "validate_#{type}".to_sym

		define_method method_name do |str|
			validate str, type
		end
	}
	end
	convenience_validators
end