class Api::V1::CapturedImagesController < Api::ApiApplicationController
  before_action :set_black_list, only: [:check]
  before_action :set_captured_image, only: [:check]

  def create
    @captured_image = CapturedImage.new(captured_image_params)
    if @captured_image.save
      face_id = SalesFaceDetector.convert_img_to_id(@captured_image.content.url)
      @captured_image.update(face_id: face_id) if face_id
    else
      render status: 400, json: {success: false, message: "parameter type is invalid."}
    end
  end

  def check
    @similarity_info = SalesFaceDetector.find_similar_face(@captured_image.face_id, @black_list.id)
    @is_sales = SalesFaceDetector.is_sales(@similarity_info)
  end

  private
  def set_black_list
    @black_list = BlackList.find(params[:black_list_id])
  end

  def set_captured_image
    @captured_image = CapturedImage.find(params[:id])
  end

  def captured_image_params
    params.permit(:content)
  end
end
