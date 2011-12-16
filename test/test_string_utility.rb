#encoding: utf-8

require 'test/unit'
require_relative '../lib/action_text'

class TestStringUtility < Test::Unit::TestCase
	def test_remove_html_tags
		str1 = "<h1>A Title</h2>"
		str2 = "a <b>bold <i>and</b> italic</i> text."
		assert_equal( "A Title", ActionText.remove_html_tags(str1) )
		assert_equal( "a bold and italic text.", ActionText.remove_html_tags(str2) )
	end

	def test_validate_email
		str1 = "MyName@example.com" #valid
		str2 = "MyExample.com" #invalid
		str3 = "Myname@example" #invalid
		assert_equal( true, ActionText.validate(str1, :email) )
		assert_equal( false, ActionText.validate(str2, :email) )
		assert_equal( false, ActionText.validate(str3, :email) )
	end

	def test_validate_url
		str1 = "http://www.example.com" #valid
		str2 = "https://example.com" #valid
		str3 = "www.example.com" #invalid
		str4 = "example.com" #invalid
		str5 = "http://example" #invalid
		assert_equal( true, ActionText.validate(str1, :url) )
		assert_equal( true, ActionText.validate(str2, :url) )
		assert_equal( false, ActionText.validate(str3, :url) )
		assert_equal( false, ActionText.validate(str4, :url) )
		assert_equal( false, ActionText.validate(str5, :url) )
	end

	def test_dynamic_validators
		str1 = "MyName@example.com" #valid
		str2 = "MyExample.com" #invalid
		str3 = "http://www.example.com" #valid
		str4 = "example.com" #invalid
		assert_equal( true, ActionText.validate_email(str1) )
		assert_equal( false, ActionText.validate_email(str2) )
		assert_equal( true, ActionText.validate_url(str3) )
		assert_equal( false, ActionText.validate_url(str4) )
	end
end