#encoding: utf-8

# This is a factory-class. Instance it, adjust your settings, and then fire your Text through it!
# You may set the parameters when you instance, by giving it a params-hash with the following structure: 
# (the default values are set in this example for clarification!)
#   params = {
#     replace_newlines: "\n", # => any newline separator you want consequently.
#     format_headlines: "remove", # => removes single lines of ascii-stuff
#     ascii_art: "remove", # => deletes all the nasty stuff from your text
#     html_optimize: "all", # => transforms "<b>" to "<strong>" and "<i>" to "<em"
#     html_filter: "casual" # => removes html tags, except some casual tags like "<br>" and "<em>
#   }
#   af = ActionFormatter.new(params)
#   nice_text = af.parse(ugly_text)
# It is also possible to change the settings via instance variables like this: 
#   af = ActionFormatter.new
#   af.replace_newlines = "<br/>"
#   nice_text = af.parse(ugly_text)
class ActionFormatter
	attr_accessor :replace_newlines, :format_headlines, :ascii_art
	attr_accessor :html_optimize, :html_filter

	# create a new Action-Formatter Object. See the class description about the params.
	def initialize params={}
		@replace_newlines = params[:replace_newlines] || "\n"
		@format_headlines = params[:format_headlines] || "remove"
		@ascii_art = params[:ascii_art] || "remove"
		@html_optimize = params[:html_optimize] || "all"
		@html_filter = params[:html_filter] || "casual"
		@tmp = "" # contains the current string
	end

	# The workhorse-method for all the transformations. Uses the given Settings and apply them
	# to the given text.
	def parse text=""
		@tmp = text.dup
		do_replace_newlines
		do_format_headlines
		do_ascii_art
		do_html_optimize
		do_html_filter
		@tmp
	end

private
	def do_replace_newlines
		@tmp.gsub!(/<br\s*\/?\s*>/, @replace_newlines)
		@tmp.gsub!("\r\n",@replace_newlines)
		@tmp.gsub!("\r",@replace_newlines)
		@tmp.gsub!("\n", @replace_newlines)
		@tmp.gsub!('\r\n', @replace_newlines)
		@tmp.gsub!('\r', @replace_newlines)
		@tmp.gsub!('\n', @replace_newlines)
		@tmp.squeeze!(" ")
	end

	def do_format_headlines
		if @format_headlines == 'remove'
			# remove ascii stuff if it occurs 3 or more times one after another
			@tmp.gsub!(/(^|\n) ([^a-z0-9] | (?:&[^;]+;) ) {3,} ($|\n)+/ix) {"#{$1}"}
		end
	end

	def do_ascii_art
		if @ascii_art == "remove"
			@tmp.gsub!(/[^\n\wäöüßÄÖÜ€\.\s]{4,}/, "")
		end
	end

	def do_html_optimize
		if @html_optimize == "all" || @html_optimize == "i"
			@tmp.gsub!(/<\s*(\/?)\s*i([^>]*)>/) {"<#{$1}em#{$2}>"}
		end
		if @html_optimize == "all" || @html_optimize == "b"
			@tmp.gsub!(/<\s*(\/?)\s*b((?:[^r>][^>]*)?)>/) {"<#{$1}strong#{$2}>"}
		end
	end

	# ToDo: let the user modify the casual tags
	def do_html_filter
		if @html_filter == "all"
			@tmp.gsub!(/<\/?[^>]*>/,'')
		elsif @html_filter == "casual"
			common_tags = []
			common_tags << "br" << "h1" << "h2" << "h3" << "h4" <<"strong"
			common_tags << "em" << "span" << "ol" <<"ul" << "li" << "p"
			common_tags.each {|tag| @tmp.gsub!( /<\s*(\/?\s*#{tag}[^>]*)>/i){"___!!!#{$1}!!!___"} }
			@tmp.gsub!(/<\/?[^>]*>/,'')
			@tmp.gsub!(/___!!!(.*?)!!!___/) {"<#{$1}>"}
		end
	end

end