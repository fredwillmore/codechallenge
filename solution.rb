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

class SequenceSearch
  NORMALIZE=97
  LETTERS=26
  
  def initialize
    @structure=[]
    # divide the search space into 26*26*26 reasonably small partitions which can be quickly found and searched
    LETTERS.times do |i|
      @structure[i] = []
      LETTERS.times do |j|
        @structure[i][j] = []
        LETTERS.times do |k|
          @structure[i][j][k] = []        
        end
      end
    end
  end
  
  def find_or_add(s)
    # derive nested array indices from first character of each word of the sequence
    i = s.word1[0].ord-NORMALIZE
    j = s.word2[0].ord-NORMALIZE
    k = s.word3[0].ord-NORMALIZE

    # search to see if the sequence has already been counted
    index = @structure[i][j][k].find_index do |item| 
      item.match s
    end

    # if the sequence has not been counted yet, add it to the appropriate partition
    # if it has, increment its count
    if index.nil?
      @structure[i][j][k] << s
    else
      @structure[i][j][k][index].increment_count
    end
  end

  def show_top
    @structure.flatten!.sort! { |a,b| b.count <=> a.count }.slice(0,100).each do |s|
      puts s.readable 
    end
    i=100
    # the following values are tied for last place
    while !@structure[i].nil? && @structure[i].count==@structure[99].count
      puts @structure[i].readable 
      i+=1
    end
  end
  
  def inspect
    @structure.each do |l1|
      l1.each do |l2|
        l2.each do |l3|
          l3.each do |s|
            puts s.readable
          end
        end
      end
    end
  end
end
  
time1 = Time.now.to_f; # simple profiling info

# read the file(s) or stream
words = ARGF.read.gsub(/[^a-zA-Z\s]/m, '').downcase.split(/\s+/)
exit if words.length < 3 

time2 = Time.now.to_f; # simple profiling info

sequence_search = SequenceSearch.new

# initialize these
word1 = words.shift
word2 = words.shift

words.each do |word3|
  sequence_search.find_or_add Sequence.new word1, word2, word3
  word1=word2 # move everybody down a step
  word2=word3
end

time3 = Time.now.to_f; # simple profiling info

sequence_search.show_top

time4 = Time.now.to_f;  # simple profiling info

puts "File Read Time: #{time2-time1}"
puts "Process Time: #{time3-time2}"
puts "Sort Time: #{time4-time3}"
