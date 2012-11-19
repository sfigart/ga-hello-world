require 'logger'
# Ruby version of JS example

class Gene
  include Comparable
  attr_reader :code, :fitness
  attr_accessor :prob_select_score
    
  def initialize(code='')
    @log = Logger.new(STDOUT)
    @log.level = Logger::WARN

    @code = code
    @fitness = 0
    
    initialize_character_set
  end
  
  def calc_fitness(compare_to)
    total = 0
    for i in 0..compare_to.size - 1
      target_value = compare_to[i]
      output_value = @code[i]

      if target_value == output_value
        total += 1000 # Correct character gets double value
      else
        total += 150 - Math.sqrt( (target_value.ord - output_value.ord) ** 2 )
      end
    end
    @fitness = total
  end
  
  def mate(other)
    @log.info "mate #{@code} - #{other.code}"
    
    pivot = (@code.size / 2)
    child1 = @code[0, pivot]      + other.code[pivot..-1]
    child2 = other.code[0, pivot] + @code[pivot..-1]
  
    return Gene.new(child1), Gene.new(child2) 
  end
  
  def mutate
    @log.info "mutate"  
    index = rand(0..@code.length-1)
    @code[index] = random_character
  end
  
  def random(length)
    @log.info "random #{length}"
    @code = ''
    length.times { @code << random_character }
    @log.debug "..#{code}"
  end
  
  def <=>(other)
    # Fitness should sort highest first (DESC)
    other.fitness <=> @fitness
  end
  
  def to_s
    "#{@code} #{@fitness}"
  end
  
  private
  
  # http://www.asciitable.com/
  def initialize_character_set
    @chars = ''
    for i in 32..126 
      @chars << i.chr
    end
  end
  
  def random_character
    @chars[rand(@chars.size)]
  end
end


