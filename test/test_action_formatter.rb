#encoding: utf-8

# just some simple unittests, not really useful. Needs much more love!

require 'test/unit'
require_relative '../lib/action_text'

class TestActionFormatter < Test::Unit::TestCase

	def test_basic_functionality
		af = ActionFormatter.new
		assert_equal( "", af.parse("") )
	end

	def test_replace_newlines
		af = ActionFormatter.new
		af.html_optimize = "none"
		af.html_filter = "none"
		af.replace_newlines = "\n"
		str1 = "This<br>is<br/>a<br />test\r\n"
		str2 = af.parse str1
		assert_equal("This\nis\na\ntest\n", str2)
	end

	def test_format_headlines
		af = ActionFormatter.new
		af.html_optimize = "none"
		af.html_filter = "none"
		af.ascii_art = "none"
		str1 = "Headline\n^*~.,.~*^"
		str2 = af.parse str1
		assert_equal("Headline\n", str2)
	end

	def test_ascii_art
		af = ActionFormatter.new
		af.html_optimize = "none"
		af.html_filter = "none"
		af.format_headlines = "none"
		af.ascii_art = "remove"
		str1 = "!!!!!!!! Call me now !!!!!!!\n"
		str2 = af.parse str1
		assert_equal(" Call me now \n", str2)
	end

	def test_html_optimize
		af = ActionFormatter.new
		af.html_filter = "none"
		str1 = "This <b>is <i>a</b> Text!</i>"
		str2 = af.parse str1
		assert_equal("This <strong>is <em>a</strong> Text!</em>", str2)
	end

	def test_html_filter
		af = ActionFormatter.new
		str1 = "This <b>is <u>a</b> Text!</u>"
		str2 = af.parse str1
		assert_equal("This <strong>is a</strong> Text!", str2)
	end
end