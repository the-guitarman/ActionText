# encoding: utf-8

require 'action_text/action_formatter'
require 'action_text/action_comparer'

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
	# with the other String and returns true or false, depending on the calculated similarity. 
	# See the ActionComparer class description for further informations. 
	def action_comparer other_text="", params={}
		ac = ActionComparer.new params
		ac.similar? self, other_text
	end

	# Initializes a new AcionComparer object with the given parameters to compare the current String with
	# an array of other strings. The result is an Array with the Strings which are more similar than 
	# allowed. See the Class definition for further informations.
	def action_comparer_many other_texts=[], params={}
		ac = ActionComparer.new params
		ac.too_similar_texts self, other_texts
	end
end

