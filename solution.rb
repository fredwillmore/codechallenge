class Sequence
  @word1
  # String @word2
  # String @word3
  # Integer @count
  
  def initialize(word1, word2, word3)
    @word1=word1
    @word2=word2
    @word3=word3 
    @count=1
  end

  # accessor functions
  def word1
    @word1
  end
  def word2
    @word2
  end
  def word3
    @word3
  end
  def count
    @count
  end
  
  def match(candidate)
    @word1==candidate.word1 && @word2==candidate.word2 && @word3==candidate.word3
  end
    
  def increment_count
    @count+=1
  end

  def readable
    "#{@count} - #{@word1} #{@word2} #{@word3}\n"
  end
end

words = ARGF.read.gsub(/[^a-zA-Z\s]/m, '').downcase.split(/\s+/)
exit if words.length < 3

sequence_search = []

# initialize these
word1 = words.shift
word2 = words.shift

words.each do |word3|
  current_sequence = Sequence.new word1, word2, word3

  word1=word2 # move everybody down a step
  word2=word3
  
  index = sequence_search.find_index do |item| 
    item.match current_sequence 
  end

  if index.nil?
    sequence_search << current_sequence
  else
    sequence_search[index].increment_count
  end
end

sequence_search.sort! { |a,b| b.count <=> a.count }

sequence_search.slice(0,100).each do |s|
  puts s.readable 
end
