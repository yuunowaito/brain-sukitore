class QuestionGenerator
  OPERATORS = [ "たす", "ひく" ].freeze

  def self.generate(previous_hand = nil)
    loop do
      count   = [ 3, 4 ].sample
      numbers = Array.new(count) { rand(1..9) }
      operators = Array.new(count - 1) { OPERATORS.sample }

      next if negative_at_any_step?(numbers, operators)

      answer  = calculate(numbers, operators)
      text    = build_text(numbers, operators)
      choices = generate_choices(answer)

      return { text: text, answer: answer, choices: choices }
    end
  end

  def self.calculate(numbers, operators)
    result = numbers[0]
    operators.each_with_index do |op, i|
      case op
      when "たす" then result += numbers[i + 1]
      when "ひく" then result -= numbers[i + 1]
      end
    end
    result
  end

  # 最終結果だけでなく、計算の途中経過でもマイナスを経由しないことを保証する
  def self.negative_at_any_step?(numbers, operators)
    result = numbers[0]
    operators.each_with_index do |op, i|
      case op
      when "たす" then result += numbers[i + 1]
      when "ひく" then result -= numbers[i + 1]
      end
      return true if result < 0
    end
    false
  end

  def self.build_text(numbers, operators)
    text = HiraganaCalculator.number_to_hiragana(numbers[0])
    operators.each_with_index do |op, i|
      text += " #{op} #{HiraganaCalculator.number_to_hiragana(numbers[i + 1])}"
    end
    text
  end

  def self.generate_choices(answer)
    choices = [ answer ]
    until choices.size == 4
      dummy = answer + rand(-5..5)
      next if dummy < 0
      choices << dummy unless choices.include?(dummy)
    end
    choices.shuffle
  end
end
