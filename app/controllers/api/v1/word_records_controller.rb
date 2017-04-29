class Api::V1::WordRecordsController < Api::ApiApplicationController
  def index
    @word_list = WordRecord.group(:word).order('count_all desc').count
  end

  def create
    if params[:text]
      voice_record = VoiceRecord.create(text: params[:text])
      voice_record_id = voice_record.id
      word_records = []
      tokenizer = SentenceTokenizer.new()
      word_arr = tokenizer.tokenize(params[:text])
      word_arr.each do |word|
        word_records << WordRecord.new(voice_record_id: voice_record_id, word: word)
      end
      WordRecord.import word_records

      render status: 200, json: { success: true}
    else
      render status: 400, json: {success: false, message: "parameter type is invalid."}
    end
  end
end
