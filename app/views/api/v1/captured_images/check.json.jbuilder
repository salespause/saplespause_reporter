json.result do
  json.id @captured_image.id
  json.is_valid @is_valid
  json.image_url @captured_image.content.url
  json.face_id @captured_image.face_id
  json.value @similarity_info[0][:confidence] if @similarity_info.present?
end
