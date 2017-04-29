json.word_list do
  json.array! @word_list do |word|
    json.word word[0]
    json.count word[1]
  end
end
