require_relative 'organism'

class Environment
  attr_reader :population, :generations

  def initialize
    @population = generate_population
    @generations = 0
  end

  def generate_population
    collection = Array.new(6, "whatever")
    collection.map do |thing|
      Organism.new(random_string)
    end
  end


  def sample_from(array)
    array.delete(array.sample)
  end

  def next_generation
    sample_population = population.clone
    until sample_population.count == 0
      parent_one = sample_from(sample_population)
      parent_two = sample_from(sample_population)
      breed(parent_one, parent_two) 
    end
    @generations += 1
  end

  def breed(parent_one, parent_two)
    offspring = create_child_from(parent_one, parent_two)
    replace_lowest_fit(parent_one, parent_two, offspring)
  end

  def create_child_from(one, two)
    new_value = create_new_value(one, two)
    offspring = Organism.new(new_value)
    offspring.value.shuffle!
    offspring
  end

  def replace_lowest_fit(parent_one, parent_two, offspring)
    parent_of_lowest_fit = lowest_fit(parent_one, parent_two)
    index_of_parent_of_lowest_fit = population.index(parent_of_lowest_fit)
    replace_parent_at(index_of_parent_of_lowest_fit, offspring)
  end

  def replace_parent_at(index, offspring)
    population[index] = offspring
  end

  def lowest_fit(one, two)
    if fitness(one) > fitness(two)
      return two
    elsif fitness(one) < fitness(two)
      return one
    else
      return [one, two].sample
    end
  end

  def overall_fitness
    population.inject(0) do |total, thing|
      total + fitness(thing)
    end
  end

  def view
    population.map do |thing|
      thing.value.join()
    end
  end

  private
  def create_new_value(parent_one, parent_two)
    one_fit = fitness(parent_one) 
    two_fit = fitness(parent_two) 
    parent_one.value.zip(parent_two.value).map do |chromo_one, chromo_two|
      random = Random.rand(0..9) 
      if (one_fit - random).abs < (two_fit - random).abs
        chromo_one
      elsif one_fit == two_fit
        [chromo_one, chromo_two].sample
      else
        chromo_two
      end
    end
  end

  def fitness(organism)
    organism.value.count('1')
  end


    def random_string
    value = (1..8).map { ['0', '1'].sample }
  end
end

env = Environment.new
20.times do
  puts env.view.join(',') + " || g #{env.generations}|| overall fitness: #{env.overall_fitness}  "
  env.next_generation
end
