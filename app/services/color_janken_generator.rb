class ColorJankenGenerator
  HANDS = [ "rock", "scissors", "paper" ].freeze
  COLORS = [ "blue", "red" ].freeze
  WINS  = { "rock" => "paper", "scissors" => "rock", "paper" => "scissors" }.freeze
  LOSES = { "rock" => "scissors", "scissors" => "paper", "paper" => "rock" }.freeze

  def self.generate(previous_hand = nil)
    loop do
      hand  = HANDS.sample
      color = COLORS.sample
      next if hand == previous_hand

      answer = color == "blue" ? WINS[hand] : LOSES[hand]

      return { hand: hand, color: color, answer: answer }
    end
  end
end
