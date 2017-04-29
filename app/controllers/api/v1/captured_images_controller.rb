class Api::V1::CapturedImagesController < Api::ApiApplicationController
  include SalesFaceDetectorAction

  def create
    @captured_image = CapturedImage.new(captured_image_params)
    if @captured_image.save
      face_id = convert_img_to_id(@captured_image.content.url)
      @captured_image.update(face_id: face_id) if face_id
    else
      render status: 400, json: {success: false, message: "parameter type is invalid."}
    end
  end

  private
  def captured_image_params
    params.permit(:content)
  end
end
