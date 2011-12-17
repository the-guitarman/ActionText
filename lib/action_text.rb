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
class ActionText
	attr_accessor :string
	attr_reader :clean, :words, :sentences
	include StringTransform

	# define some utility class methods through the eigenclass
	class << self
		include StringUtility
	end

	# Create a new ActionText object with the given String. Optional you can set the 'format' flag
	# to 'false' when you don't want to clean up the string. Which actions are performed when cleaning
	# up the string you can read in the StringTransform module.
	def initialize str, params={}
		@string = str # the original given string
		@format = params["format"] || params[:format] || true
		@clean = format_interpunctuation(@string)
		if @format
			@_words = split_to_words @clean
			@_sentences = split_to_sentences @clean
		else
			@_words = split_to_words @string
			@_sentences = split_to_sentences @string
		end
		@words = @_words.size
		@sentences = @_sentences.size
	end

	# Transforms the ActionText object back to a usual String. If you set the clean-flag to true you
	# will get the pretty formatted string, otherwise you will get exactly the string you used to
	# create the ActionText object. default: true. 
	def to_s clean=true
		if clean
			@clean.dup
		else
			@string.dup
		end
	end

	# returns an array of all the words in the text
	def list_words
		@_words
	end

	# returns an array of all the sentences in the text
	def list_sentences
		@_sentences
	end

	# A mighty test method! It looks in the text and checks whether the given string is included
	# in the text. You can specify some special behaviour how the method should treat the given string
	# by setting some flags to true/false. The current list of flags is: 
	# - :roughly #=> is the string included in any form? setting this flag to true will ignore all other flags!
	#   default: FALSE.
	# - :ignore_case #=> tells the internal regexp's to test all case combinations, too. default: TRUE.
	# - :separate_words #=> When true, the method will by words, NOT by signs!
	# <b>ATTENTION</b> this method is not implemented until now!
	def include? str=nil, flags={}
		return false unless str && (str.kind_of?(String) || str.kind_of?(ActionText)) 
		roughly = flags["roughly"] || flags[:roughly] || false #the master-flag
		ignore_case = flags["ignore_case"] || flags[:ignore_case] || true
		separate_words = flags["separate_words"] || flags[:separate_words] || false
	end

	# The most simple include case. Simply look if the given String is exactly included in the Text.
	def includes_string? target, ignore_case=true
		return false unless target && (target.kind_of?(String) || target.kind_of?(ActionText)) 
		if ignore_case
			@clean =~ /#{target}/i ? true : false
		else
			@clean =~ /#{target}/ ? true : false
		end
	end

	# The advanced include method which checks for words, NOT for single signs.
	def includes_words? target, ignore_case=true
		return false unless target && (target.kind_of?(String) || target.kind_of?(ActionText))
		words = split_to_words target, format: true
		all_words_included = true
		if ignore_case
			words.each {|w| all_words_included = false unless @clean =~ /#{w}/i }
		else
			words.each {|w| all_words_included = false unless @clean =~ /#{w}/ }
		end
		all_words_included
	end
end