require "test/unit"

require_relative "population"

class TestPopulation < Test::Unit::TestCase

  def test_initialize
    population = Population.new("one", 20, 'output.txt', 10000, 0.5, 0.1)
    assert_equal('one', population.goal)
    assert_equal(20, population.members.size)
    assert_equal(0, population.generation_number)
  end
  
  def test_population_members_code_size
    population = Population.new("one", 20, 'output.txt', 10000, 0.5, 0.1)
    assert_equal('one'.size, population.members.first.code.size)

    population = Population.new("three", 20, 'output.txt', 10000, 0.5, 0.1)
    assert_equal('three'.size, population.members.last.code.size)    
  end

  def test_generation_simple
    population = Population.new("h w", 20, 'output_small.txt', 1000, 0.5, 0.1)
    found = false
    limit = 1000
    while !found && population.generation_number < limit      
      found = population.generation
      print '.'
    end
    puts "Ended in generation: #{population.generation_number}"
    assert_equal(true, found)
  end

  def test_generation_medium
    population = Population.new("good day", 20, 'output_medium.txt', 1000, 0.5, 0.1)
    found = false
    limit = 20000
    while !found && population.generation_number < limit      
      found = population.generation
      print '.'
    end
    puts "Ended in generation: #{population.generation_number}"
    assert_equal(true, found)
  end

=begin
  def test_generation
    population = Population.new("cat", 20, 'output_hello_world.txt')
    found = false
    limit = 100000
    while !found && population.generation_number < limit      
      found = population.generation
      if population.generation_number % 10 == 0
        print "\r#{population.generation_number} \
         #{population.members[0]} #{population.members[1]} \
         #{population.members[2]} #{population.members[3]}"
      end
    end
    puts "Ended in generation: #{population.generation_number} with #{found}"
    puts "Code: #{population.members.first.code} Cost: #{population.members.first.cost}"
    assert_equal(true, found)
  end
=end
end