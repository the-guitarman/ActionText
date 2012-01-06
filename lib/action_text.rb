# encoding: utf-8

require_relative 'action_text/string_transform'
require_relative 'action_text/string_utility'
require_relative 'action_text/string_compare'

# just a little tweak for convenience usage.
class String
	# extends the String Class to transform itself in an ActionText object.
	def to_text
		ActionText.new self
	end
end

# This is the main class where all the magic happens. Just instance an ActionText object, 
# or use <code>mystring.to_text</code> and you will have all the nice usability methods. 
# What is the difference between a "text" and a "string"?
# - Build nice looking sentences from ugly formatted strings.
# - Check if other strings or even words or whole sentences are included in the text. 
# - compare texts for similarity (not just equality!). Very useful if you don't want texts
#   that are too similar! In addition, you can fluently set the grad of accuracy. 
# - Ask the text if it is a valid type, eg. if it is a valid email-adress or url. 
# - As this gem is developed for usage in Germany, of course the german 'umlauts' are handled
#   naturally. 
# Here's a sample code to show some features of ActionText: <code>
#   text_1 = 'Hello! This is a nice little sample text!'.to_text
#   text_1.list_sentences #=> ['Hello!','This is a nice little sample text!']
#   text_1.list_words #=> ['Hello','This','is','a','nice','little','sample','text']
#   text_1.include? 'HELLO' #=> true
#   text_1.include? 'HELLO', ignore_case: false #=> false
#   text_1.include? 'text sample' #=> false
#   text_1.includes_words? 'nice little sample' #=> true
#   text_1.words #=> 8 
#   text_1.sentences #=> 2
# </code>
# <code>
#   text_2 = 'This is uglyVery!ugly sentence!!!'.to_text
#   text_2.text #=> 'This is ugly. Very! ugly sentence!'
# </code>
# <code>
#   text_3 = 'AnEmailAdress@Example.com'.to_text
#   text_3.is_a_valid :email #=> true
#   text_3.is_a_valid :url #=> false
# </code>
# <code>
#   text_4 = 'a <b>styled</b> text.'.to_text
#   text_4.remove_html #=> 'a styled text.'
# </code>
# the last method is also usable standalone: 
# <code>
#   ActionText.remove_html 'a <b>styled</b> text.' #=> 'a styled text.'
# </code>
# To check the similarity of two Strings or ActionText-objects, just use
# the <code>match</code> method. You may set the size of the units you want to compare with the :by
# parameter
# - <code>by: 'chars'</code>
# - <code>by: 'words'</code>
# - <code>by: 'sentences'</code>
# Depending on your choice the results are very different! The default case is <code>:words</code>,
# which is very suitable for medium text sizes. Some samples: 
# <code>
#   txt = ActionText.new "This is a simple text."
#	  str1 = "Completely different!"
#   str2 = "Another simple text?"
#   str3 = "This is a simple text"
#   txt.match str1, by: 'words' #=> 0.0
#   txt.match str2, by: 'words' #=> 8/15 or 0.533333333
#   txt.match str3, by: 'words' #=> 1.0
# </code>
class ActionText
	attr_accessor :string
	attr_reader :text, :words, :sentences
	include StringTransform

	# define some utility class methods through the eigenclass
	class << self
		include StringUtility
		include StringCompare
	end

	# Create a new ActionText object with the given String. Optional you can set the 'format' flag
	# to 'false' when you don't want to clean up the string. Which actions are performed when cleaning
	# up the string you can read in the StringTransform module.
	def initialize str, params={}
		@string = str # the original given string
		@format = params["format"] || params[:format] || true
		@text = format_interpunctuation(@string)
		set_params
	end

	# Synonym for my_action_text_object.string. Returns exactly the String which was used to 
	# create this ActionText object. 
	def to_s
		@string
	end

	# returns the ActionText-object itself. Just a helper method for handling such objects like 
	# they were strings.
	def to_text
		self
	end

	# returns an array of all the words in the text
	def list_words
		@_words
	end

	# returns an array of all the sentences in the text
	def list_sentences
		@_sentences
	end

	# the core mathing method to get the factor of similarity between the current ActionText-object
	# and a given string or, for a better result, another ActionText-object
	def match str, flags={}
		return 1.0 unless str
		separator = (flags['by'] || flags[:by] || :words).to_sym
		str1 = format_remove_non_letters @text
		str2 = format_remove_non_letters str.to_text.text
		self.class.compare str1, str2, separator
	end

	# a simple subroutine for testing issues.
	def match_relative str, flags={}
		return 1.0 unless str
		separator = (flags['by'] || flags[:by] || :words).to_sym
		str1 = format_remove_non_letters @text
		str2 = format_remove_non_letters str.to_text.text
		self.class.compare_relative str1, str2, separator
	end

	# A mighty test method! It looks in the text and checks whether the given string is included
	# in the text. You can specify some special behaviour how the method should treat the given string
	# by setting some flags to true/false. The current list of flags is: 
	# - :ignore_case #=> tells the internal regexp's to test all case combinations, too. default: TRUE.
	def include? str=nil, flags={}
		return false unless str && (str.kind_of?(String) || str.kind_of?(ActionText)) 
		ignore_case = flags["ignore_case"] || flags[:ignore_case]
		ignore_case = true if ignore_case == nil
		includes_string? str, ignore_case
	end

	# The most simple include case. Simply look if the given String is exactly included in the Text.
	def includes_string? target, ignore_case=true
		return false unless target && (target.kind_of?(String) || target.kind_of?(ActionText)) 
		if ignore_case
			@text =~ /#{target}/i ? true : false
		else
			puts @text
			@text =~ /#{target}/ ? true : false
		end
	end

	# The advanced include method which checks for words, NOT for single signs.
	def includes_words? target, ignore_case=true
		return false unless target && (target.kind_of?(String) || target.kind_of?(ActionText))
		words = split_to_words target, format: true
		all_words_included = true
		if ignore_case
			words.each {|w| all_words_included = false unless @text =~ /#{w}/i }
		else
			words.each {|w| all_words_included = false unless @text =~ /#{w}/ }
		end
		all_words_included
	end

	# ask the text if it is a valid <code>type</code>, where type could be
	# <code>:email</code> or <code>:url</code>. Sample: 
	# 
	# <code>"MyExample@example.com".to_text.is_a_valid :email #=> true</code>
	def is_a_valid type=nil
		return false unless type && type.respond_to?(:to_s)
		self.class.send "validate_#{type}".to_sym, @string
	end

	# deletes all html-tags from the text
	def remove_html
		self.class.remove_html_tags @text
	end

	# removes every html-tag in the given string
	def self.remove_html str
		remove_html_tags str
	end

	def force_newline type = :unix
		if type == :unix || type == 'unix'
			@text.gsub! "\r\n","\n"
		elsif type == :windows || type == 'windows'
			@text.gsub! "\n","\r\n"
		end
	end

private
	def set_params
		if @format
			force_newline :unix
			@_words = split_to_words @text
			@_sentences = split_to_sentences @text
		else
			@_words = split_to_words @string
			@_sentences = split_to_sentences @string
		end
		@words = @_words.size
		@sentences = @_sentences.size
	end

end