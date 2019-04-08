require 'mini_magick'

# class for building collage
class Collage
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def build_collage(images)
    column_count = Integer.sqrt(images.length)
    row_count = (images.length.to_f / column_count.to_f).ceil
    max_width = calculate_max_width(images)
    create_background_image(max_width, column_count, row_count)
    background = MiniMagick::Image.new('./tmp/background.jpg')
    count_image = 1
    x = 0
    y = 0
    images.each do |value|
      second_image = MiniMagick::Image.new("./tmp/#{value[:filename]}")
      background = background.composite(second_image) do |c|
        c.compose 'Over'
        c.geometry "+#{x}+#{y}"
      end
      if count_image == column_count
        x = 0
        y += max_width
        count_image = 1
      else
        x += max_width
        count_image += 1
      end
    end
    background.write 'output.jpg'
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def create_background_image(max_width, column_count, row_count)
    MiniMagick::Tool::Convert.new do |i|
      i.size "#{max_width * column_count}x#{max_width * row_count}"
      i.xc 'white'
      i << './tmp/background.jpg'
    end
  end

  def calculate_max_width(images)
    max_width = 0
    images.each { |img| max_width = img[:width] if img[:width] > max_width }
    max_width
  end
end
