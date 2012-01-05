#encoding: utf-8

# This module adds some basic StringProcessing methods to ActionText for convenient usage.
module StringTransform

	# A Bunch of transformations to style text in a non-ugly text format. For Example take
	# this String: 
	# 
	# <code>"A test StringAnother Sentence!!!The End - Really, the end."</code>
	# 
	# after calling this method, you will get the following string: 
	# 
	# <code>"A test String. Another Sentence! The End. Really, the end."</code>
	def format_interpunctuation str
		new_str = str.dup
		new_str.gsub!(" - ", ". ")
		new_str.gsub!(/([a-z|äöüß])([A-Z|ÄÖÜ])/) { "#{$1}. #{$2}" }
		new_str.gsub!(/\!+/,"!")
		new_str.gsub!(/\?+/,"?")
		new_str.gsub!(/([\!|\?|\.])([\w|äöüÄÖÜß])/) { "#{$1} #{$2}"}
		new_str
	end

	# This simple formatter deletes every character from the string, which is usually
	# not used in texts. Also it purges ?!. and prepares the string to get split
	# into single words. For a far better experience, set the <code>:format</code> flag to true (this
	# will use the format_interpunctuation method before processing)
	def format_remove_non_letters str, flags={}
		format = flags[:format] || flags['format'] || true
		new_str = format ? format_interpunctuation(str) : str.dup
		new_str.gsub!(/[^\w|öäüÖÄÜß|\ |\'|\"']/,'')
		new_str
	end

	# This handy method uses the format_remove_non_letters method first, and then splits the
	# string into an array of single words. For way better results, use the format_interpunctuation
	# first or set the <code>:format</code> flag to true.
	def split_to_words str, flags={}
		format = flags[:format] || flags['format'] || true
		str = format_interpunctuation(str) if format
		string_without_special_signs = format_remove_non_letters(str)
		string_without_special_signs.split(" ")
	end

	# This method is exspecially useful for longer texts. You can break this text up into nice
	# sentences. If you set the <code>:format</code> flag to true, the format_interpunctuation method
	# will be used before splitting to get often better results! 
	def split_to_sentences str, flags={}
		format = flags[:format] || flags['format'] || false
		str = format_interpunctuation(str) if format
		string_with_separators = str.gsub(/([\.|\!|\?])\ /) { "#{$1}[*!*breakpoint*!*]" }
		@sentences = string_with_separators.split("[*!*breakpoint*!*]")
	end
end