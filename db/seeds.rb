# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Create black_list
home_id = 4
name = 'test'
image_names = [
    'ide.jpg',
    'lady1.jpg',
    'lady2.jpg',
    'lady3.jpg',
    'lady4.jpg',
    'lady5.jpg',
]

puts "===create black list==="
black_list = BlackList.create(home_id: home_id, name: name)
SalesFaceDetector.create_face_list(black_list.id, black_list.name)

# add someone to black_list
puts "===add someone to black list==="
image_names.each do |image_name|
  image = File.open("public/seed_face_list/#{image_name}")
  captured_image = CapturedImage.create(content: image)
  puts captured_image.content.url
  face_id = SalesFaceDetector.convert_img_to_id(captured_image.content.url)
  captured_image.update(face_id: face_id) if face_id
  SalesFaceDetector.add_face_to_list(captured_image.content.url, black_list.id)
  black_list.face_images.create(image_url: captured_image.content.url, face_id: face_id)
end




