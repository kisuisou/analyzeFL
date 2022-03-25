require "exifr/jpeg"
require "ascii_charts"
def drawHistogram(img_dir_path)
  imgs_path=Array.new
  imgs_exif=Array.new
  imgs_chart_args=Array.new
  Dir.foreach(img_dir_path) do |path|
    path=img_dir_path+path
    next if (/\.jpg|\.jpeg|\.png/i=~File.extname(path))==nil||File.extname(path)==""
    imgs_path.push(path)
    exif_data=EXIFR::JPEG.new(path)
    imgs_exif.push(exif_data)
  end
  imgs_exif.sort_by!{|x|x.focal_length_in_35mm_film.to_i}
  imgs_exif.each do |exif_data|
    fl = exif_data.focal_length_in_35mm_film.to_i
    fl_ary_now_exists = imgs_chart_args.transpose[0]
    if fl_ary_now_exists != nil && fl_ary_now_exists.include?(fl)
      imgs_chart_args.map!{|len_data|len_data[0]==fl ? [fl,len_data[1]+1] : len_data}
    else
      imgs_chart_args.push([fl,1])
    end
  end
  puts AsciiCharts::Cartesian.new(imgs_chart_args,:bar => true, :hide_zero => true).draw
end
def pathValidation
  loop do
    puts "焦点距離を調査したい写真が存在するディレクトリの絶対パスを入力してください。"
    print '--->'
    inputPath = STDIN.gets.chomp
    if (%r|\A/([^\\:*<>?"\|/]+/)*[^\\:*<>?"\|/]*\Z| =~ inputPath)==nil
      puts 'パスが不正です'
      next
    elsif !(Dir.exist?(inputPath))
      puts 'ディレクトリが存在しません'
      next
    elsif !(File.ftype(inputPath) == 'directory')
      puts 'ディレクトリではありません'
      next
    end
    return inputPath[-1] == '/' ? inputPath : inputPath << '/'
    break
  end
end
drawHistogram(pathValidation)
