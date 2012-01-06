require_relative 'helper'

class TestSamples < Test::Unit::TestCase

	def test_sample_text_1
		text_1 = 'Hello! This is a nice little sample text!'.to_text
		assert_equal( text_1.list_sentences, ['Hello!','This is a nice little sample text!'])
		assert_equal( text_1.list_words, ['Hello','This','is','a','nice','little','sample','text'])
		assert_equal( text_1.include?('HELLO'), true)
		assert_equal( text_1.include?('HELLO', ignore_case: false), false)
		assert_equal( text_1.include?('text sample'), false)
		assert_equal( text_1.includes_words?('nice little sample'), true)
		assert_equal( text_1.words, 8)
		assert_equal( text_1.sentences, 2)
	end

	def test_sample_text_2
		text_2 = 'This is uglyVery!ugly sentence!!!'.to_text
		assert_equal( text_2.text, 'This is ugly. Very! ugly sentence!')
	end

	def test_sample_text_3
		text_3 = 'AnEmailAdress@Example.com'.to_text
		assert_equal( text_3.is_a_valid(:email), true)
		assert_equal( text_3.is_a_valid(:url), false)
	end

	def test_sample_text_4
		text_4 = 'a <b>styled</b> text.'.to_text
		assert_equal( text_4.remove_html, 'a styled text.')
		assert_equal( ActionText.remove_html('a <b>styled</b> text.'), 'a styled text.')
	end

end