$VERBOSE = nil
require 'flickr_fu'
require 'parallel'
require 'mini_magick'
require 'sms_digital_challenge/collage'
require 'sms_digital_challenge/version'
module SmsDigitalChallenge
  class Error < StandardError; end

  # download at least 10 top rated images from Flickr and build a collage
  # rubocop:disable Metrics/ClassLength
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/PerceivedComplexity
  class ImageDownloader
    # rubocop:disable Metrics/CyclomaticComplexity
    def initialize(
        path_to_yml,
        path_to_dic = File.expand_path('../dic.txt', File.dirname(__FILE__))
      )
      raise(ArgumentError, 'you didnt give me a valid path to the yml') if
          !path_to_yml.is_a?(String) || !File.exist?(path_to_yml) ||
          !File.extname(path_to_yml) == '.yml'

      raise(ArgumentError, 'you didnt give me a valid path to the dic') if
          !path_to_dic.is_a?(String) || !File.exist?(path_to_dic)

      err_msg = 'the dic file is not a text file(.txt) /
 or file size to big (16MB)'
      raise(ArgumentError, err_msg) unless
          File.extname(path_to_dic) == '.txt' &&
          (File.size(path_to_dic).to_f / 2**20).round(2) <= 16

      @path_to_yml = path_to_yml
      @path_to_dic = path_to_dic
      @dic = []
      read_dic_from_file
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def download(keywords = [], output = 'output.jpg')
      err_msg = 'you didnt give me a keyword list as array like object!'
      raise(ArgumentError, err_msg) unless keywords.respond_to?('each')

      puts('get image urls for keywords')
      image_urls = download_image_urls(build_final_keyword_list(keywords))
      Dir.mkdir('./tmp') unless File.exists?('./tmp')
      puts('download images in tmp')
      tmp_images = {}
      images = []
      Parallel.map(image_urls, in_threads: 5) do |_, value|
        filename = value[:url].split('/').last
        width = download_image(value[:url], './tmp/' + filename)
        tmp_images[filename] = { value: value[:value], width: width }
      end
      tmp_images.each do |filename, value|
        count = 0
        while count < value[:value]
          images.push(filename: filename, width: value[:width])
          count += 1
        end
      end
      puts('build collage')
      collage = Collage.new
      collage.build_collage(images)
      puts('finish')
    end

    private

    def read_dic_from_file
      File.foreach(@path_to_dic) do |line|
        @dic.push(line)
      end
      raise(ArgumentError, 'no words inside dic file') if @dic.empty?
    end

    def remove_not_working_words_from_dic(keywords)
      keywords.each { |word| @dic.delete(word) } unless @dic.empty?
    end

    def next_keyword_from_dic
      raise 'all words in dic file are not working' if @dic.empty?

      @dic[rand(@dic.length)]
    end

    def clear_keyword_list(keywords)
      encountered = {}
      keywords.each do |keyword|
        if encountered[keyword]
          encountered[keyword] += 1
        else
          encountered[keyword] = 1
        end
      end
      encountered
    end

    def build_final_keyword_list(keywords)
      temp_keywords = []
      keywords.each do |keyword|
        if keyword.respond_to?('to_str')
          temp_keywords.push(keyword.to_str)
        else
          temp_keywords.push(next_keyword_from_dic)
        end
      end
      temp_keywords.push(next_keyword_from_dic) while temp_keywords.length < 10
      clear_keyword_list(temp_keywords)
    end

    def download_image_urls(keywords)
      still_not_found_all_urls = true
      images_urls = {}
      temp_keywords = keywords.clone
      while still_not_found_all_urls
        not_working_keywords = {}
        Parallel.map(temp_keywords, in_threads: 5) do |keyword, value|
          begin
            photos = Flickr.new(@path_to_yml).photos.search(
              tags: keyword,
              text: keyword,
              sort: 'interestingness-desc'
            )
            if photos.total.zero? || photos.photos[0].url.nil?
              not_working_keywords[keyword] = value
            else
              images_urls[keyword] = { url: photos.photos[0].url, value: value }
            end
          rescue
            puts('could not get img path for keyword cause of internet failure')
          end
        end
        if not_working_keywords.empty?
          still_not_found_all_urls = false
        else
          temp_keywords = {}
          remove_not_working_words_from_dic(not_working_keywords)
          not_working_keywords.each do |_, value|
            new_keyword = next_keyword_from_dic
            if images_urls[new_keyword]
              images_urls[new_keyword] = {
                url: images_urls[new_keyword][:url],
                value: images_urls[new_keyword][:value] + value
              }
            else
              temp_keywords[new_keyword] = value
            end
          end
        end
      end
      images_urls
    end

    def download_image(url, dest)
      MiniMagick::Tool::Convert.new do |i|
        i << url.to_s
        i.resize '100x100'
        i.gravity 'center'
        i.extent '100x100'
        i << dest.to_s
      end
      100
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/ClassLength
end
