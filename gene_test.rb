require "test/unit"

require_relative "gene"

class TestGene < Test::Unit::TestCase
  
  def test_initialize
    gene = Gene.new('12345')
    assert_equal('12345', gene.code)
    
    gene = Gene.new
    assert_equal(0, gene.fitness)
  end
  
  def test_random
    gene = Gene.new
    gene.random(10)
    assert_equal(10, gene.code.size)
  end
  
  def test_mutate
    gene = Gene.new('TEST')
    assert_equal('TEST', gene.code)
    gene.mutate
    assert_not_equal('TEST', gene.code)
  end
  
  def test_mate
    gene = Gene.new("ONETWO")
    other = Gene.new("BIGBOX")
    child1, child2 = gene.mate(other)
    assert_equal('ONEBOX', child1.code)
    assert_equal('BIGTWO', child2.code)
  end
  
  def test_fitness
    gene = Gene.new("A")
    gene.calc_fitness("A")
    assert_equal(1000, gene.fitness)

    gene.calc_fitness("B")
    assert_equal(149, gene.fitness)
    
    gene = Gene.new("apple")
    gene.calc_fitness("apple")
    assert_equal(5000, gene.fitness)

    gene.calc_fitness("bpple")
    assert_equal(4149, gene.fitness)
    
    gene.calc_fitness("bppld")
    assert_equal(3298, gene.fitness)
    
    gene.calc_fitness("cpple")
    assert_equal(4148, gene.fitness)
    
    gene.calc_fitness("dpple")
    assert_equal(4147, gene.fitness)

    gene.calc_fitness("dpplc")
    assert_equal(3295, gene.fitness)
  end
  
  def test_sort
    z = Gene.new("zero")
    a = Gene.new("aero")
    m = Gene.new("main")

    z.calc_fitness("zero")
    a.calc_fitness("zero")
    m.calc_fitness("zero")
    
    array = [a, z, m]
    sorted = array.sort
    
    assert_equal(z, sorted[0])
    assert_equal(a, sorted[1])
    assert_equal(m, sorted[2])
  end
end