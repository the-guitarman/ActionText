#encoding: utf-8

require 'action_text/similarity_checker'

# This is a factory-class. Instance it, adjust your settings, and then fire your Texts through it!
# You may set the parameters when you instance, by giving it a params-hash with the following structure: 
# (the default values are set in this example for clarification!)
#   params = {
#     similarity_limit: 0.7 # => define the equality for the compare-many method.
#     size_limit: 0.3 #=> define the limit for which size difference texts are definitivly different.
#   }
#   ac = ActionComparer.new(params)
#   equality = ac.similar?(str1, str2) # => true / false
#   *TODO* too_equal_texts = ac.compare_many(str1, [ary of strings])
class ActionComparer
	attr_accessor :similarity_limit, :size_limit
	include SimilarityChecker

	# create a new Action-Comparer Object. See the class description about the params.
	def initialize params={}
		@size_limit = params[:size_limit] || 0.3
		@similarity_limit = params[:similarity_limit] || 0.7
	end

  # Give this method two texts, and let it calculate whether they're too similar. Uses the defined limits in the constructor.
	def similar? text1, text2
		check(text1, text2) > @similarity_limit ? true : false
	end

  # Use this convenience method if you want to check many files against one text. This method uses the similar? method
  # and returns all texts which are too similar ans an Array. 
	def too_similar_texts text1, other_texts=[]
		other_texts.map{|text| text if similar?(text1, text)}.compact
	end
	
end
