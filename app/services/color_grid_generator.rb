class ColorGridGenerator
  GRID_SIZE = 16

  def self.generate(target_count: 3)
    target_count = [target_count, 5].min
    sample = random_cells(target_count)
    answer = generate_answer(sample, target_count)
    { sample: sample, answer: answer}
  end

  def self.random_cells(count)
    (0...GRID_SIZE).to_a.sample(count)
  end

  def self.generate_answer(sample, count)
    loop do
      answer = random_cells(count)
      return answer unless answer.sort == sample.sort
    end
  end
end