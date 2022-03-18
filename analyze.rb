require "exifr/jpeg"
require "ascii_charts"
IMG_DIR_PATH="/home/kisui/Pictures/sample/"
imgs_path=Array.new
imgs_exif=Array.new
imgs_chart_args=Array.new
Dir.foreach(IMG_DIR_PATH) do |path|
  path=IMG_DIR_PATH+path
  next if File.extname(path)!=".jpg"
  imgs_path.push(path)
  exif_data=EXIFR::JPEG.new(path)
  imgs_exif.push(exif_data)
end
imgs_exif.sort_by!{|x|x.focal_length_in_35mm_film.to_i}
imgs_exif.each do |exif_data|
  focal_length = exif_data.focal_length_in_35mm_film.to_i
  array_tmp = imgs_chart_args.map{|length|length[0]}
  if array_tmp.include?(focal_length)
    imgs_chart_args[imgs_chart_args.length-1] = [focal_length,imgs_chart_args[imgs_chart_args.length-1][1]+1] 
  else
    imgs_chart_args.push([focal_length,1])
  end
end
puts AsciiCharts::Cartesian.new(imgs_chart_args,:bar => true, :hide_zero => true).draw
