require_relative 'population'
# http://burakkanber.com/blog/machine-learning-genetic-algorithms-part-1-javascript/

# Change these values ---------------------------------------------
#goal             = 'CSC 578 Neural Networks and Machine Learning!'
goal             = 'Hello, World!'
population_size  = 100
output_file      = 'output_hello_world.txt'
limit            = 10000
replacement_rate = 0.5
mutation_rate    = 0.1
# -----------------------------------------------------------------


puts "\r\nPopulation Size: #{population_size}"
puts "Crossover Rate : #{replacement_rate * 100}%"
puts "Mutation Rate  : #{mutation_rate * 100}%"
puts "Goal           :\t#{goal}\r\n\r\n"
puts "Generation\tCurrent Best Hypothesis\t\t\tFitness"
10.times do
  population = Population.new(goal, population_size, output_file, limit, replacement_rate, mutation_rate)
  found = false

  while !found && population.generation_number < limit      
    found = population.generation
    if population.generation_number % 10 == 0
      print "\r#{population.generation_number}\t#{population.members[0]}"
    end
  end
end