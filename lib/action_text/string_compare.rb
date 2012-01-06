#encoding: utf-8

# This Module implements the core comparison functionality.
module StringCompare

	# some naming aliases for convenience usage
	@@separators = {
		word: ' ',
		words: ' ',

		string: '',
		signs: '',
		sign: '',
		chars: '',
		char: '',

		sentence: '. ',
		sentences: '. '
	}

	def compare str1, str2, separator
		factor1 = compare_relative str1, str2, separator
		factor2 = compare_relative str2, str1, separator
		(factor1 + factor2) / 2
	end

	def compare_relative str1, str2, separator
		separator = @@separators[separator]
		separator ||= ' '
		counter = 0.0
		chars = str2.split separator
		#puts chars.to_s
		if separator == ''
			chars.each {|c| counter += 1 if str1 =~ /#{Regexp.escape(c)}/i }
		elsif separator == ' '
			chars.each {|c| counter += 1 if str1.downcase =~ /(\s|^)#{Regexp.escape(c.downcase)}(\s|$)/i }
		end
		counter / chars.size
	end
=begin
	# could be: 
	# compare_(string|word|words)(_relative) str, str
	def method_missing(method, *args)
		# extract the parameters
		name = method.to_s
		super unless name =~ /compare/i
		mode = (name.match /_(\w*)_*/).to_s[1..-2] || super
		separator = "" if mode =~ /string/i
		separator = " " if mode =~ /word/i
		super unless separator && args[0] && args[1]

		# redirect to matching methods if parameters are ok
		if name =~ /relative/i
			compare_relative(args[0], args[1], separator)
		else
			compare(args[0], args[1], separator)
		end
	end
=end
end