require 'net/http'
require 'json'

module TagCloud

  class TagCloud

    attr_accessor :word_frequency_hash
    attr_accessor :bigram_frequency_hash
    attr_accessor :word_idea_freq_hash

    def initialize(boardId)
      @board = Board.find_by_id boardId
      @highest_freq_words_info = WordFrequency.new
      @segment_uri = "http://max-prob-segment.herokuapp.com/api/segment?segment.lang.en=true&segment.uppercaseall=true&segment.halfsharpall=true"
      @word_frequency_hash = {}
      @bigram_frequency_hash = {}
      @word_idea_freq_hash = {}
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

    def get_segment_result
      uri = URI.parse(@segment_uri)
      resource = Net::HTTP.new(uri.host, uri.port)

      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = JSON.generate(get_idea_list)
      request.initialize_http_header({"Content-Type" => "application/vnd.ideaboardy; charset=UTF-8"})

      response = resource.request(request)
      if (response.code == "200")
        @segment_result = JSON.parse(response.body)
      else
        @segment_result = []
      end
      @segment_result
    end

    def analyze_segment_result
      analyze_idea_segment_result get_segment_result()
    end

    def get_analysis_result
      result = get_bigram_as_phrase()
      sorted_pairs = @word_frequency_hash.sort_by { |key, value| value }
      sorted_pairs.reverse.each do |pair|
        word = pair[0]
        if(!(@highest_freq_words_info.is_high_freq_word word))
          result << {"name" => word, "weight" => pair[1], "df" => @word_idea_freq_hash[word]}
        end
      end

      result[0, 20]
    end

    def get_bigram_as_phrase
      result = []
      sorted_bigram = @bigram_frequency_hash.sort_by { |key, bigram| bigram.count * bigram.ideas.size }
      sorted_bigram.reverse!
      if(sorted_bigram[0][1].ideas.size > 1)
        result << {"name" => sorted_bigram[0][0], "weight" => sorted_bigram[0][1].count, "df" => sorted_bigram[0][1].ideas.size}
      end
      result
    end

    private
    def analyze_idea_segment_result(segment_result)
      segment_result.each do |idea|
        statistic_each_idea(idea)
      end
    end

    def statistic_each_idea(idea)
      segment_result = idea['segmentResult']
      statistic_idea_freq(segment_result)
      segment_word_freq(idea, segment_result)
      statistic_bigram(idea)
    end

    def segment_word_freq(idea, segment_result)
      segment_result.each_with_index do |word_atom, index|
        word = word_atom['word']
        pos = word_atom['pos']
        if(pos != "W" && pos != "Q" && pos != "M")
          @word_frequency_hash[word] = @word_frequency_hash[word].to_i + (idea['vote'] + 1)
        end
      end
    end

    def statistic_idea_freq(segment_result)
      segment_result.uniq.each do |word_atom|
        word = word_atom['word']
        @word_idea_freq_hash[word] = @word_idea_freq_hash[word].to_i + 1
      end
    end

    def statistic_bigram(idea)
      segment_result = idea['segmentResult']
      segment_result.each_with_index do |word_atom, index|
        word = word_atom['word']
        if (index < segment_result.size - 1)
          bigram = Bigram.new(word, segment_result[index + 1]['word'])
          @bigram_frequency_hash[bigram.to_s] = bigram unless @bigram_frequency_hash.include? bigram.to_s
          @bigram_frequency_hash[bigram.to_s].count += 1
          @bigram_frequency_hash[bigram.to_s].ideas << idea['id']
          @bigram_frequency_hash[bigram.to_s].ideas.uniq!
        end
      end
    end

  end

  class Bigram
    attr_accessor :first_word
    attr_accessor :second_word
    attr_accessor :count
    attr_accessor :ideas

    def initialize(first_word, second_word)
      @first_word = first_word
      @second_word = second_word
      @count = 0
      @ideas = []
    end

    def to_s
      if is_en
        "#{@first_word} #{@second_word}"
      else
        "#{@first_word}#{@second_word}"
      end
    end

    private
    def is_en
      @first_word.match("[A-z]+") != nil and @second_word.match("[A-z]+") != nil
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
  end

  class WordFrequency

    def initialize
      @most_freq_words = ["a", "able", "about", "above", "across", "add", "after", "again", "against", "ago", "air", "all",
                          "almost", "alone", "along", "already", "also", "although", "always", "am", "american", "among",
                          "an", "and", "animal", "animals", "another", "answer", "any", "anything", "are", "area", "around",
                          "as", "ask", "at", "away", "back", "ball", "be", "beautiful", "became", "because", "become", "been",
                          "before", "began", "begin", "behind", "being", "below", "best", "better", "between", "big",
                          "black", "blue", "boat", "body", "book", "both", "bottom", "box", "boy", "bring", "brought",
                          "build", "built", "but", "by", "called", "came", "can", "cannot", "car", "care", "carefully",
                          "carry", "center", "certain", "change", "check", "children", "city", "class", "close", "cold",
                          "come", "common", "complete", "could", "country", "course", "cut", "dark", "day", "deep",
                          "did", "different", "distance", "do", "does", "dog", "done", "door", "down", "draw", "dry",
                          "during", "each", "early", "earth", "easy", "eat", "either", "else", "end", "english",
                          "enough", "even", "ever", "every", "everyone", "everything", "example", "face", "fact", "fall",
                          "family", "far", "fast", "father", "feel", "feet", "felt", "few", "field", "finally", "find",
                          "fine", "fire", "first", "fish", "five", "floor", "follow", "food", "foot", "for", "form",
                          "found", "four", "friend", "from", "front", "full", "game", "gave", "get", "girl", "give",
                          "glass", "go", "going", "gold", "gone", "good", "got", "great", "green", "ground", "group",
                          "grow", "had", "half", "hand", "happened", "hard", "has", "have", "he", "head", "hear", "heard",
                          "heart", "heavy", "held", "help", "her", "here", "high", "him", "himself", "his", "hold", "home",
                          "horse", "hot", "hour", "house", "how", "however", "hundred", "i", "ice", "idea", "if", "important",
                          "in", "inside", "instead", "into", "is", "it", "its", "itself", "job", "just", "keep", "kept",
                          "kind", "knew", "know", "land", "language", "large", "last", "later", "lay", "learn", "learned",
                          "least", "leave", "leaves", "left", "less", "let", "letter", "life", "light", "like", "line",
                          "list", "little", "live", "lived", "living", "long", "longer", "look", "low", "made", "main",
                          "make", "man", "many", "map", "matter", "may", "me", "mean", "men", "might", "mind", "miss",
                          "money", "moon", "more", "morning", "most", "mother", "move", "much", "must", "my", "name",
                          "near", "need", "never", "new", "next", "night", "no", "not", "nothing", "notice", "now", "number",
                          "of", "off", "often", "oh", "old", "on", "once", "one", "only", "open", "or", "order", "other",
                          "our", "out", "outside", "over", "own", "page", "paper", "part", "past", "pattern", "people",
                          "perhaps", "person", "picture", "piece", "place", "plants", "play", "point", "poor", "possible",
                          "power", "probably", "problem", "put", "question", "quite", "rain", "ran", "read", "reading",
                          "ready", "real", "really", "red", "remember", "rest", "right", "river", "road", "rock", "room",
                          "round", "run", "sad", "said", "same", "sat", "saw", "say", "school", "sea", "second", "see",
                          "seen", "sentence", "set", "several", "she", "shell", "ship", "short", "should", "show", "shown",
                          "side", "simple", "since", "six", "size", "sky", "small", "snow", "so", "some", "someone",
                          "something", "soon", "sound", "space", "special", "stand", "start", "state", "states", "stay",
                          "still", "stood", "stop", "story", "strong", "study", "such", "suddenly", "summer", "sun", "sure",
                          "surface", "system", "table", "take", "talk", "tall", "tell", "ten", "than", "that", "the",
                          "their", "them", "themselves", "then", "there", "these", "they", "thing", "think", "third",
                          "this", "those", "though", "thought", "three", "through", "time", "tiny", "to", "today",
                          "together", "told", "too", "took", "top", "toward", "town", "tree", "true", "try", "turn",
                          "turned", "two", "under", "understand", "united", "until", "up", "upon", "us", "use", "usually",
                          "very", "voice", "walked", "want", "warm", "was", "watch", "water", "way", "we", "weather",
                          "well", "went", "were", "what", "when", "where", "whether", "which", "while", "white", "who",
                          "whole", "why", "wide", "wild", "will", "wind", "winter", "with", "within", "without", "words",
                          "work", "world", "would", "write", "year", "yes", "yet", "you", "young", "your"].sort.uniq
    end

    def is_high_freq_word word
      @most_freq_words.include? word.downcase
    end

  end

end