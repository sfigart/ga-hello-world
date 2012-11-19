require 'logger'
require_relative 'gene'
require_relative 'writer'

class Population
  attr_reader :members, :goal, :generation_number, :r, :m
  
  def initialize(goal, size, output_file='output.txt', limit, replacement_rate, mutation_rate)
    @log = Logger.new(STDOUT)
    @log.level = Logger::WARN
    @log.info "initialize #{goal} #{size}"

    @goal = goal
    @generation_number = 0
    @limit = limit
    @r = replacement_rate
    @m = mutation_rate
    
    initialize_population(size)
    
    @writer = Writer.new(output_file)
    write_header
  end
  
  def run()
    found = false
    while !found && @generation_number < @limit      
      found = generation
    end
  end
  
  def generation
    @log.info "generation #{@generation_number}"
    evaluate
    display
    
    @new_members = select_some_members
    @new_members.concat(crossover)
    mutate_new_members
    @members = @new_members
    
    @members.each do |member|
      member.calc_fitness(@goal)
      
      if member.code == @goal
        puts "\r\n#{@generation_number}\t#{member.code}\t<--- Solution\r\n"
        sort!
        display_final
        return true
      end
    end
    
    @generation_number += 1
    false
  end
  
  private

  def evaluate
    @members.each { |member| member.calc_fitness(@goal) }
  end
  
  def mutate_new_members
    num_to_select = (@m * @new_members.size).to_i
    num_to_select.times do 
      @new_members.sample.mutate
    end  
  end

  def sort_by_probability
    total_fitness = @members.map(&:fitness).inject(:+)
    @members.each do |member|
      member.prob_select_score = member.fitness / total_fitness
    end
    # Sort in descending order (Largest to smallest)
    @members.sort_by{|member| member.prob_select_score}.reverse!
  end
    
  def select_some_members
    sorted = sort_by_probability
    num_to_select = (1 - @r) * @members.size
    
    # Return the top num_to_select
    sorted[0, num_to_select]  
  end
  
  def crossover
    sorted = sort_by_probability
    num_to_select = (@r * @members.size) / 2
    
    children = []
    paired_population = sorted.each_slice(2).to_a
    for i in 0..num_to_select - 1
      child1, child2 = paired_population[i][0].mate(paired_population[i][1])
      children << child1
      children << child2
    end
    children
  end
  
  def create_children
    @log.info "create_children"
    
    child1, child2 = @members[0].mate(@members[1])
    
    @log.debug "..members size before: #{@members.size}"
    # Remove the last two members
    @members.slice!(-2,2)
    
    @log.debug "..members size after : #{@members.size}"
    
    # add children
    @members << child1
    @members << child2
    @log.debug "..members size final : #{@members.size}"
  end
  
  def write_header
    @writer.puts "generation code cost fitness population_size goal_size"
  end
  
  def display
    if (@generation_number % 10) == 0 # Print only every tenth record
      @writer.puts "#{@generation_number} #{@members.first.code} #{@members.first.fitness} #{@members.size} #{@goal.size}"
    end
  end

  def display_final
    @writer.puts "#{@generation_number} #{@members.first.code} #{@members.first.fitness} #{@members.size} #{@goal.size}"
  end
  
  def initialize_population(size)
    @log.info "initialize_population"
    
    @members = []
    size.times do
      gene = Gene.new
      gene.random(@goal.size)
      @members << gene
    end
  end
  
  def sort!
    @log.info "sort!"
    @members.sort!
  end
end