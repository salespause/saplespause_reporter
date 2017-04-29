class SalesFaceDetector
  def self.convert_img_to_id(image_url)
    #=== 画像をazure上でのidに変換する関数
    # @input <str> faceImgUrl: 画像のpath or url を渡す
    # @output <str> response.body[0][:faceId]: 登録されたfaceIDが帰ってくる. face listに突っ込んで永久かしないと、このidは24時間で消える
    #
    puts '[SalesFaceDetector] <convert_img_to_id> fire'
    uri = URI('https://southeastasia.api.cognitive.microsoft.com/face/v1.0/detect')
    uri.query = URI.encode_www_form({
                                        'returnFaceId' => 'true'
                                    })
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request['Ocp-Apim-Subscription-Key'] = "#{Settings.azure.face_api_key}"
    body = "{
      'url' : '#{image_url}'
    }"
    request.body = body
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end
    response.body = eval(response.body)
    puts "[SalesFaceDetector] <convert_img_to_id> response.body[0][:faceId]: #{response.body[0][:faceId]}"
    if response.present?
      return response.body[0][:faceId]
    else
      return nil
    end
  end

  def self.create_face_list(face_list_id, list_name)
    #=== 検索に用いるfacelistを作成する関数
    # @input <str> faceListId: idを任意に作れる. このidをpathのお尻につけてpostすることでリストを作れる
    # @input <str> listName: 作るリストに名前作れる
    # @output <str> faceListId: 作ったfacelistのid. 顔画像を追加する時に, このidを利用する
    # 注意: 1回実行すれば十分(使うリストは一つ blackList)
    puts '[SalesFaceDetector] <create_face_list> fire'
    uri = URI("https://southeastasia.api.cognitive.microsoft.com/face/v1.0/facelists/#{face_list_id}")
    request = Net::HTTP::Put.new(uri)
    request['Content-Type'] = 'application/json'
    puts "[SalesFaceDetector] <convert_img_to_id> Settings.azure.face_api_key: #{Settings.azure.face_api_key}"
    request['Ocp-Apim-Subscription-Key'] = Settings.azure.face_api_key
    body = "{
      'name': '#{list_name}',
      'userData':'User-provided data attached to the face list'
    }"
    request.body = body
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end
    puts "[SalesFaceDetector] <create_face_list> response.body: #{response.body}"
    return face_list_id
  end

  def self.add_face_to_list(image_url, face_list_id)
    #=== facelistに顔画像を追加する関数. 営業マンの顔を追加することを想定している
    # @input <str> faceImgUrl: faceImgUrl: 追加したい画像のpath or url を渡す
    # @input <str> faceListId: 画像を追加する対象のリストのid
    # @output <str> response.body['persistedFaceId']: リストに追加された, 永久化された画像id
    puts '[SalesFaceDetector] <add_face_to_list> fire'
    uri = URI("https://southeastasia.api.cognitive.microsoft.com/face/v1.0/facelists/#{face_list_id}/persistedFaces")
    uri.query = URI.encode_www_form({
                                    })
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request['Ocp-Apim-Subscription-Key'] = Settings.azure.face_api_key
    body = "{
      'url' : '#{image_url}'
    }"
    request.body = body
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end
    response.body = eval(response.body)
    puts "[SalesFaceDetector] <add_face_to_list> response.body['persistedFaceId']: #{response.body['persistedFaceId']}"
    return response.body['persistedFaceId']
  end

  def self.find_similar_face(face_id, face_list_id)
    #=== facelistの中から、似ている顔を検索する関数
    # @input <str> faceId: 類似顔を検索する時のクエリ. convert_img_to_id()の返り値. 画像のidを表す.
    # @input <str> faceListId: 画像を追加する対象のリストのid. create_face_list()の返り値
    # @output <str> response.body: 類似顔の結果. 似ている顔が確信度順に返される. [{id: , 確信度: }...]で帰ってくる
    puts '[SalesFaceDetector] <findSimilarFace> fire'
    uri = URI('https://southeastasia.api.cognitive.microsoft.com/face/v1.0/findsimilars')
    uri.query = URI.encode_www_form({
                                    })
    request = Net::HTTP::Post.new(uri.request_uri)
    request['Content-Type'] = 'application/json'
    request['Ocp-Apim-Subscription-Key'] = Settings.azure.face_api_key
    body = "{
      'faceId':'#{face_id}',
      'faceListId':'#{face_list_id}',
      'maxNumOfCandidatesReturned':'10',
      'mode': 'matchPerson'
    }"
    request.body = body
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end
    puts eval(response.body)
    return eval(response.body)
  end

  def self.is_sales(face_similar_list)
    mostSimilarFace = face_similar_list[0]
    confidence = mostSimilarFace[:confidence]
    if confidence > 0.5 then
      puts "true"
      return true
    else
      puts "false"
      return false
    end
  end
end
