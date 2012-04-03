#encoding: utf-8

# just some simple unittests, not really useful. Needs much more love!

require 'test/unit'
require_relative '../lib/action_text'

class TestStringIntegration < Test::Unit::TestCase

	def test_basic_functionality
		params = {
			html_filter: "none",
			html_optimize: "none"
		}
		str1 = "A Simple \r\n Test String"
		assert_equal("A Simple \n Test String", str1.action_formatter(params) )
	end

end