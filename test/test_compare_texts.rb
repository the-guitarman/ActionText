#encoding: utf-8

require_relative 'helper'

class TestCorrectComparison < Test::Unit::TestCase

	def test_matching_relative
		txt1 = ActionText.new "Hello, World!"
		txt2 = ActionText.new "a very cool test text"
		txt3 = ActionText.new "Hällo Wörld!"
		str1 = "Hello world."
		str2 = "what a beautiful world"
		str3 = "hällo text!"
		assert_equal( 1.0, 	txt1.match_relative(str1, by: 'words') )
		assert_equal( 0.25, txt1.match_relative(str2, by: 'words') )
		assert_equal( 0.25, txt2.match_relative(str2, by: 'words') )
		assert_equal( 0.5, 	txt2.match_relative(str3, by: 'words') )
		assert_equal( 0.0, 	txt3.match_relative(str1, by: 'words') )
		assert_equal( 0.5, 	txt3.match_relative(str3, by: 'words') )
	end

	def test_with_strings
		txt = ActionText.new "This is a simple text."
		str1 = "Completely different!"
		str2 = "Another simple text?"
		str3 = "This is a simple text"
		assert_equal( 0.0, txt.match(str1, by: 'words') )
		assert_equal( 0.0, txt.match(str1, by: 'sentences') )
		assert_equal( 2.0/3, txt.match_relative(str2, by: 'words') )
		assert_equal( 2.0/5, str2.to_text.match_relative(txt.string, by: 'words') )
		assert_equal( ((2.0/5)+(2.0/3))/2, txt.match(str2, by: 'words') )
		assert_equal( 1.0, txt.match(str3, by: 'words') )
	end

	def test_strings_with_umlauts
		txt1 = ActionText.new "Ein einfacher Text."
		txt2 = ActionText.new "Ein schöner Text"
		str1 = "ein Text!"
		str2 = "ein schöner tag."
		str3 = "ein schöner Text."
		assert( 0.8 < txt1.match(str1, by: 'words') && txt1.match(str1, by: 'words') < 0.9 )
		assert_equal( 1.0/3, txt1.match(str2, by: 'words') )
		assert_equal( 2.0/3, txt1.match(str3, by: 'words') )
		assert_equal( 2.0/3, txt2.match(str2, by: 'words') )
		assert_equal( 1.0/1, txt2.match(str3, by: 'words') ) 
	end

	def test_action_texts
		txt1 = ActionText.new "Hello, World!"
		txt2 = ActionText.new "Hello World!!"
		assert_equal( 1.0, txt1.match(txt2) )
	end

end