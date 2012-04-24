#encoding: utf-8

# This mixin-module uses the SOUNDEX-algorithm,
# with the fastest possible implementation in native ruby.
# uses a instance variable @size_limit in the instance mixed in,
# for fine-tune the text sizes (performance vs. accuracy!)

module SimilarityChecker

  def check text1, text2
    # Need the AF class to prepare the texts for splitting into words
    af = ActionFormatter.new({
      replace_newlines: " ",
      format_headlines: "none",
      ascii_art: "none",
      html_optimize: "none",
      html_filter: "all"
    })

    # clean from html-tags, non-words, and split into an array of unique words
    tmp1 = af.parse(text1).gsub(/[^\w\s]/,'').split(' ').uniq
    tmp2 = af.parse(text2).gsub(/[^\w\s]/,'').split(' ').uniq

    # get the sizes (number of words), > @size_limit (default: 30%) difference == ok
    size1 = tmp1.size
    size2 = tmp2.size
    average_size = (size1 + size2) / 2.0
    limit = average_size * (1 + @size_limit)
    return 0.0 if (size1 >= limit) or (size2 >= limit)

    # translate to soundex-codes and compare
    ary1 = tmp1.map{|word| soundex(word)}.uniq
    ary2 = tmp2.map{|word| soundex(word)}.uniq
    size1 = ary1.size
    size2 = ary2.size
    average_size = (size1 + size2) / 2.0
    difference = (ary1 - ary2).size

    # rate the difference
    # value 0.0 == completely different and 1.0 == equal
    (average_size - difference) / average_size
  end

  def soundex_letter letter
    char = letter.upcase
    return "1" if %w( B F P V ).include? char
    return "2" if %w( C G J K Q S X Z ).include? char
    return "3" if %w( D T ).include? char
    return "4" if "L" == char
    return "5" if %w( M N ).include? char
    return "6" if "R" == char
    return "0"
  end

  def soundex word
    first, remain = word[0], word[2 .. -1].to_s + "   "
    remain.gsub!(/aeiou/i, '')
    first + "-" + remain.split('')[0 .. 2].map{|l| soundex_letter(l)}.join("")
  end
end
