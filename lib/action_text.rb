# encoding: utf-8

require_relative 'action_text/action_formatter'
require_relative 'action_text/action_comparer'

# Just a little tweak for convenience usage. Extend the String class with some shorthand methods
# to use ActionFormatter and ActionComparer without explicit need for instancing that classes. 
class String
	
	# extends the String Class to transform itself in an ActionFormatter object, works through the filters, 
	# and returns the pretty new String. See the ActionFormatter 
	# description about the params. 
	def action_formatter params={}
		af = ActionFormatter.new params
		af.parse self
	end

	# Initializes a new ActionComparer object with the given parameters, compare the current String 
	# with the other String and returns the similarity factor (a float between 0.0 and 1.0). 
	# See the ActionComparer class description for further informations. 
	def action_comparer other_text="", params={}
		ac = ActionComparer.new params
		ac.compare_pair self, other
	end

	# Initializes a new AcionComparer object with the given parameters to compare the current String with
	# an array of other strings. The result is an Array with the Strings which are more similar than 
	# allowed. See the Class definition for further informations.
	def action_comparer_many other_texts=[], params={}
		ac = ActionComparer.new params
		ac.compare_many self, other_texts
	end
end

