class SentenceTokenizer

  def initialize
    Rjb::load('lib/kuromoji-0.7.7/lib/kuromoji-0.7.7.jar')
    tokenizer = Rjb::import('org.atilika.kuromoji.Tokenizer')
    @tknizer = tokenizer.builder.build
  end

  def tokenize(sentence)
    arr = []
    list = @tknizer.tokenize(sentence)
    list.extend JavaIterator
    list.each do |x|
      print x.surface_form
      print " : "
      print x.part_of_speech #名詞、助詞....

      kind = x.part_of_speech.split(",")[0]
      arr << x.surface_form if kind == "名詞"
    end
    arr
  end
end

module JavaIterator
  def each
    i = self.iterator
    while i.has_next
      yield i.next
    end
  end
end

