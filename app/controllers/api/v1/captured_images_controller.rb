class Api::V1::CapturedImagesController < Api::ApiApplicationController
  def create
    @captured_image = CapturedImage.new(captured_image_params)
    if @captured_image.save
    else
    end
  end

  private
  def captured_image_params
    params.permit(:content)
  end
end
