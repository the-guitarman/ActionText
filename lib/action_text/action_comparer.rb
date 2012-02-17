#encoding: utf-8

# This is a factory-class. Instance it, adjust your settings, and then fire your Texts through it!
# You may set the parameters when you instance, by giving it a params-hash with the following structure: 
# (the default values are set in this example for clarification!)
#   params = {
#     modifier: "auto", # => split by: "words", "sentences" or "chars". "auto" chooses the best modifier.
#     limit: 0.75 # => define the equality for the compare-many method. See this method for further info.
#   }
#   ac = ActionComparer.new(params)
#   equality = ac.compare_pair(str1, str2)
#   too_equal_texts = ac.compare_many(str1, [ary of strings])
# It is also possible to change the settings via instance variables like this: 
#   ac = ActionComparer.new
#   ac.modifier = "words"
#   equality = ac.compare_pair(str1, str2)
#   too_equal_texts = ac.compare_many(str1, [ary of strings])
class ActionComparer
	attr_accessor :modifier, :limit

	# create a new Action-Comparer Object. See the class description about the params.
	def initialize params={}
		@modifier = params[:modifier] || "auto"
		@limit = params[:limit] || 0.75
	end

	# Check two Strings for equality. Uses the @modifier for splitting the Strings. The result is
	# a Float with the similarity-factor. 
	def compare_pair text="", other=""
		compare text, other, @modifier
	end

	# Check a String against a bunch of other Strings. Uses the @modifier for splitting the Strings
	# and returns an Array of Strings which have a higher similarity-factor than the given @limit. 
	def compare_many text="", others=[]
		others.map{|str| 
			str if compare_pair(text, str) > @limit
		}.compact
	end

private
	# ToDo: define "auto"-modifier
	def compare text_1="", text_2="", by="words"
		by = "words" if by == "auto" #placeholder
		result_1 = self.send("compare_by_#{by}_relative".to_sym, text_1, text_2)
		result_2 = self.send("compare_by_#{by}_relative".to_sym, text_2, text_1)
		(result_1 + result_2) / 2.0
	end

	def compare_by_chars_relative text_1, text_2
		amount_of_matching_chars = text_1.split("").map{|char|
			true if text_2 =~ /#{Regexp.escape char}/
		}.compact.length
		amount_of_matching_chars.to_f / text_1.length.to_f
	end

	def compare_by_words_relative text_1, text_2
		words = text_1.split(" ")
		amount_of_matching_words = words.map{|word|
			true if text_2 =~ /#{Regexp.escape word}/
		}.compact.length
		amount_of_matching_words.to_f / words.size.to_f
	end

	def compare_by_sentences_relative text_1, text_2
		sentences = get_sentences_from_string text_1
		amount_of_matching_sentences = sentences.map{|sentence|
			true if text_2 =~ /#{Regexp.escape sentence}/
		}.compact.length
		amount_of_matching_sentences.to_f / sentences.size.to_f
	end

	def get_sentences_from_string text=""
		sentences = []
		text.gsub(/([\wäöüÄÖÜß]+?(\.|\?|!)+?(\s|\z))/){sentences.push $1}
		sentences
	end
end