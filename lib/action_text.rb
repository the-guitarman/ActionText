# encoding: utf-8

require_relative 'action_text/string_transform'
require_relative 'action_text/string_utility'
require_relative 'action_text/string_compare'

class String
	# xtends the String Class to transform itself in an ActionText object.
	def to_text
		ActionText.new self
	end
end

class ActionText
	attr_accessor :string
	attr_reader :string_clean, :words, :length, :size, :sentences
	include StringTransform

	# define some utility class methods through the eigenclass
	class << self
		include StringUtility
	end

	# Create a new ActionText object with the given String. Optional you can set the 'format' flag
	# to 'false' when you don't want to clean up the string. Which Actions are performed when cleaning
	# up the string you can read in the StringTransform module.
	def initialize str, params={}
		@formatted = params["format"] || params[:format] || true
		@string = str # the original given string

		@string_clean = @formatted ? format_interpunctuation(@string) : @string.dup # the @string in an better formatted way
		@words = split_to_words @string_clean # an array of all the words inside the string
		@length = @words.length # counts the number of words in the text
		@size = @words # an alias for @length
		@sentences = split_to_sentences @string_clean #split up the given text into sentences if possible
	end

	# Transforms the ActionText object back to a usual String. If you set the clean-flag to true you
	# will get the pretty formatted string, otherwise you will get exactly the string you used to
	# create the ActionText object.
	def to_s clean=false
		if clean
			@string_clean.dup
		else
			@string.dup
		end
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
		return false unless str
		roughly = flags["roughly"] || flags[:roughly] || false #the master-flag
		ignore_case = flags["ignore_case"] || flags[:ignore_case] || true
		separate_words = flags["separate_words"] || flags[:separate_words] || false

	end

	# The most simple include case. Simply look if the given String is exactly included in the Text.
	def includes_full_string? target, ignore_case=true
		return false unless target && (target.kind_of?(String) || target.kind_of?(ActionText)) 
		if ignore_case
			@string_clean =~ /#{target}/i ? true : false
		else
			@string_clean = ~ /#{target}/ ? true : false
		end
	end

	# The advanced include method which checks for words, NOT for single signs.
	def includes_all_words? target, ignore_case=true
		return false unless target && (target.kind_of?(String) || target.kind_of?(ActionText))
		cleaned_target = format_remove_non_letters(format_interpunctuation(target))
		words = split_to_words(cleaned_target)
		all_words_included = true
		if ignore_case
			words.each {|w| all_words_included = false unless @string_clean =~ /#{w}/i }
		else
			words.each {|w| all_words_included = false unless @string_clean =~ /#{w}/ }
		end
		all_words_included
	end
end