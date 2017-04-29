json.captured_image do
  json.id @captured_image.id
  json.image_url @captured_image.content.url
  json.face_id @captured_image.face_id
end
