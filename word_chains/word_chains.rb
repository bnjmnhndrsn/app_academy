require 'set'
require 'debugger'

class WordChains
  def initialize(dictionary)
    @dictionary = Set.new(dictionary)
  end
  
  def run(beginning, target)
    @same_length = @dictionary.select { |word| word.length == beginning.length }
    @visited = Set.new
    @first_to_visit = {}
    queue = [beginning]
    until queue.empty?
      word = queue.shift
      matches = find_matches(word, target)
      matches.each do |match| 
        @first_to_visit[match] = word unless @first_to_visit.include?(match)
        return get_chain(match, beginning) if match == target
        queue << match
        @visited.add(match)
      end
    end
    
    false
  end
  
  def find_matches(word, target)
    regexes = create_regex(word)
    @same_length.select do |word|
      regexes.any? { |regex| regex =~ word } && !@visited.include?(word)
    end
  end
  
  def create_regex(word)
    (0...word.length).map do |i|
      new_word = word.dup
      new_word[i] = "."
      Regexp.new(new_word)
    end
  end
  
  def get_chain(start, target)
    return [start] if start == target
    [start] + get_chain(@first_to_visit[start], target)
  end
end

if $PROGRAM_NAME == __FILE__
  dictionary = File.readlines("dictionary.txt").map(&:chomp)
  chainer = WordChains.new(dictionary)
  a = chainer.run("ruby","duck")
  p a
end