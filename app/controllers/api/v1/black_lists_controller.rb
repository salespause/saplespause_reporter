class Api::V1::BlackListsController < Api::ApiApplicationController
  before_action :set_black_list, only: [:add]

  def create
    black_list = BlackList.new(black_list_params)
    if black_list.save
      SalesFaceDetector.create_face_list(black_list.id, black_list.name)
    else
      return render status: 400, json: {success: false, message: "parameter type is invalid."}
    end
    return render status: 200, json: { success: true, id: black_list.id, name: black_list.name}
  end

  def add
    face_id,image_url = nil
    if params.keys.include?('image_url')
      image_url = params[:image_url]
      face_id = SalesFaceDetector.convert_img_to_id(image_url)
    elsif params.keys.include?('image')
      captured_image = CapturedImage.create(content: params[:image])
      face_id = SalesFaceDetector.convert_img_to_id(captured_image.content.url)
      image_url = captured_image.content.url
      captured_image.update(face_id: face_id) if face_id
    else
      return render status: 400, json: {success: false, message: "parameter type is invalid."}
    end
    SalesFaceDetector.add_face_to_list(image_url, @black_list.id)
    @black_list.face_images.create(image_url: image_url, face_id: face_id)

    render status: 200, json: { success: true }
  end

  private

  def set_black_list
    @black_list = BlackList.find(params[:id])
  end

  def black_list_params
    params.permit(
        :name,
        :home_id
    )
  end
end
