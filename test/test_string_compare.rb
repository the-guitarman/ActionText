#encoding: utf-8

require 'test/unit'
require_relative '../lib//action_text/string_compare'

class TestStringCompare < Test::Unit::TestCase
	include StringCompare

	def test_core_functionality
		str1 = "abcd"
		str2 = "efgh"
		str3 = "abef"
		str4 = "aghi"
		assert_equal( 0.0, compare_strings_relative(str1, str2) )
		assert_equal( 0.5, compare_strings_relative(str1, str3) )
		assert_equal( 0.25, compare_strings_relative(str1, str4))
	end

	def test_core_with_umlauts
		str1 = "häy!"
		str2 = "juli"
		str3 = "Wät?"
		assert_equal( 0.0, compare_strings_relative(str1, str2) )
		assert_equal( 0.25, compare_strings_relative(str1, str3) )
	end

	def test_comparing_words
		str1 = "What a beautiful text"
		str2 = "cool different test string"
		str3 = "What a ugly method"
		assert_equal( 0.0, compare_words(str1, str2) )
		assert_equal( 0.5, compare_words(str1, str3) )
	end
end