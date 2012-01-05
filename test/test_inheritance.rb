#encoding: utf-8

require 'test/unit'
require_relative '../lib/action_text'

class TestInheritanceOfActionText < Test::Unit::TestCase
	def test_initialize
		str = "A text."
		assert_equal( str, ActionText.new(str).string )
	end

	def test_inheritance
		str = "A text."
		assert_equal( str, str.to_text.string )
	end

	def test_string_cleanup
		str1 = "HelloWorld"
		str2 = "Hi!!! Whats up??"
		str3 = "As I said...you're a fool!!"
		assert_equal("Hello. World", str1.to_text.text)
		assert_equal("Hi! Whats up?", str2.to_text.text)
		assert_equal("As I said... you're a fool!", str3.to_text.text)
	end

	def test_splitting_words
		str1 = "HelloWorld"
		str2 = "Hi!!! Whats up??"
		str3 = "As I said...you're a fool!!"
		assert_equal( ["Hello","World"], str1.to_text.list_words )
		assert_equal( ["Hi","Whats","up"], str2.to_text.list_words )
		assert_equal( ["As","I","said","you're","a","fool"], str3.to_text.list_words)
	end

	def test_umlauts
		str1 = "HelloWörld"
		assert_equal( ["Hello","Wörld"], str1.to_text.list_words)
	end

	def test_sentences
		str1 = "A sentence. This too? yes!"
		str2 = "Hi!!! Whats up??"
		str3 = "As I said...you're a fool!!"
		assert_equal( ["A sentence.","This too?","yes!"], str1.to_text.list_sentences)
		assert_equal( ["Hi!","Whats up?"], str2.to_text.list_sentences )
		assert_equal( ["As I said...","you're a fool!"], str3.to_text.list_sentences )
	end

	def test_include_strings
		txt = ActionText.new "This is a sentence. With many many words. You see?"
		str2 = "a sentence"
		str3 = "A sentence."
		assert_equal( true, txt.includes_string?(str2) )
		assert_equal( true, txt.includes_string?(str3) )
		assert_not_equal( true, txt.includes_string?(str3, false) )
	end

	def test_include_words
		txt = ActionText.new "This is a sentence. With many many words. You see?"
		str2 = "a sentence"
		str3 = "with many, many words."
		str4 = "With many words."
		str5 = "with! many! words!"
		assert_equal( true, txt.includes_words?(str2) )
		assert_equal( true, txt.includes_words?(str3) )
		assert_equal( true, txt.includes_words?(str4, false))
		assert_equal( true, txt.includes_words?(str5) )
		assert_not_equal( true, txt.includes_words?(str5,false) )
	end

	def test_self_validation
		str1 = "MyEmail@Example.com"
		str2 = "WorstCase@Example.com"
		str3 = "Mail@example"
		str4 = "http://example.com"
		str5 = "http://www.example.com"
		str6 = "example.com"
		assert_equal( true, str1.to_text.is_a_valid(:email) )
		assert_equal( true, str2.to_text.is_a_valid(:email) )
		assert_equal( false, str3.to_text.is_a_valid(:email) )
		assert_equal( true, str4.to_text.is_a_valid(:url) )
		assert_equal( true, str5.to_text.is_a_valid(:url) )
		assert_equal( false, str6.to_text.is_a_valid(:url) )
	end
end