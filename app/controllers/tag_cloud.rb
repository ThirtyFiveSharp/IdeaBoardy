require 'net/http'
require 'json'

module TagCloud

  class TagCloud

    attr_accessor :word_frequency_hash

    def initialize(boardId)
      @board = Board.find_by_id boardId
      @segment_uri = "http://max-prob-segment.herokuapp.com/api/segment?segment.lang.en=true&segment.uppercaseall=true&segment.halfsharpall=true"
      @word_frequency_hash = {}
    end

    def get_idea_list
      idea_list = []
      @board.sections.each do |section|
        section.ideas.each do |idea|
          idea_doc = IdeaDocument.new(idea, section, @board)
          idea_list << idea_doc
        end
      end
      idea_list
    end

    def to_s
      text = ""
      get_idea_list.each { |idea| (0..(idea.vote + 1)).to_a.each {text += idea.to_s + "\n"} }
      text
    end

    def get_segment_result
      uri = URI.parse(@segment_uri)
      resource = Net::HTTP.new(uri.host, uri.port)

      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = self.to_s
      request.initialize_http_header({"Content-Type" => "text/plain; charset=UTF-8"})

      response = resource.request(request)
      if (response.code == "200")
        @segment_result = JSON.parse(response.body)
      else
        @segment_result = []
      end
    end

    def analyze_segment_result
      analyze_idea_segment_result get_segment_result()
    end

    def get_analysis_result
      sorted_pairs = @word_frequency_hash.sort_by {|key, value| value}
      result = []
      sorted_pairs.reverse.each do |pair|
        result << {"name" => pair[0], "weight" => pair[1]}
      end
      result
    end

    private
    def analyze_idea_segment_result(segment_result)
      segment_result.each_with_index do |word, index|
        @word_frequency_hash[word['word']] = @word_frequency_hash[word['word']].to_i + 1
      end
    end

  end

  class IdeaDocument

    attr_accessor :id
    attr_accessor :content
    attr_accessor :vote
    attr_accessor :tags
    attr_accessor :section_name
    attr_accessor :section_id
    attr_accessor :board_name
    attr_accessor :board_id

    def initialize(idea, section, board)
      @segment_uri = "http://max-prob-segment.herokuapp.com/api/segment?segment.lang.en=true&segment.uppercaseall=true&segment.halfsharpall=true"
      @id = idea.id
      @content = idea.content
      @vote = idea.vote
      @tags = idea.tags
      @section_name = section.name
      @section_id = section.id
      @board_name = board.name
      @board_id = board.id
    end

    def to_s
      "#{content}"
    end
  end

end