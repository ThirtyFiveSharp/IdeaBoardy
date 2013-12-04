module ShortenUrl

  def get_origin_url(shorten_url, query_str = nil)
    shorten_url = shorten_url[1, shorten_url.length] if shorten_url.start_with? "/"
    return nil if (shorten_url =~ /^[0-9A-z,\.]+$/).nil?

    origin_url = nil
    number = to_id(shorten_url).to_s
    api_code = number[0,4]
    template = get_path_template api_code
    origin_url = template.gsub(/\{0\}/, number[4, number.length]) unless template.nil?
    origin_url += "?" + query_str unless query_str.nil? || origin_url.nil?
    origin_url
  end

  def get_shorten_url(api, id)
    api_code = get_api_code(api)
    return nil if api_code.nil?
    number = (api_code.to_s + id.to_s).to_i
    to_number_62(number)
  end

  def get_api_code(api)
    api_code_map = paths[api.to_sym]
    return api_code_map[:api_code] unless api_code_map.nil?
    nil
  end

  def to_number_62(decimal_number)
    raise "input number must be greater than zero" unless decimal_number > 0
    id = decimal_number
    url = []
    while id > 0
      url << characters[id % 62]
      id = id / 62
    end
    url.reverse.join("")
  end

  def to_id(decimal_str)
    number = 0
    power = decimal_str.length - 1
    decimal_str.each_char do |c|
      number += characters.index(c) * (62**power)
      power -= 1
    end
    number
  end

  private
  def characters
    %w(0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z)
  end

  def get_path_template(api_code)
    paths.keys.each do |key|
      return paths[key][:template] if paths[key][:api_code] == api_code.to_i
    end
    nil
  end

  def paths
    {
        :api_board => {:template => "#{ENV['RAILS_RELATIVE_URL_ROOT']}/api/boards/{0}", :api_code => 1000}
    }
  end
end