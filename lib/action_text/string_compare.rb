#encoding: utf-8

# This Method implements the core comparisom functionality. You may use the both core methods
# if you like, but the preferred way is to use a special method depending on the comparison
# you want to do. General, the following keywords are known: 
# - string #=> compare char by char
# - word #=> compare word by word
# - sentence (not yet implemented)
# also, there is always the <code>relative</code> keyword you might set. For a detailed instruction
# how the methods work in general, read the descriptions of compare and compare_relative. 
module StringCompare

private
	def compare str1, str2, separator=""
		factor1 = compare_relative str1, str2, separator
		factor2 = compare_relative str2, str1, separator
		(factor1 + factor2) / 2
	end

	def compare_relative str1, str2, separator=""
		counter = 0.0
		chars = str2.split separator
		chars.each {|c| counter += 1 if str1 =~ /#{Regexp.escape(c)}/ }
		counter / chars.size
	end

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

end