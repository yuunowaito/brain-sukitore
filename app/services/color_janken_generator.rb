class ColorJankenGenerator
  HANDS = [ "rock", "scissors", "paper" ].freeze
  COLORS = [ "blue", "red" ].freeze
  WINS  = { "rock" => "paper", "scissors" => "rock", "paper" => "scissors" }.freeze
  LOSES = { "rock" => "scissors", "scissors" => "paper", "paper" => "rock" }.freeze

  def self.generate
    hand  = HANDS.sample
    color = COLORS.sample
    answer = color == "blue" ? WINS[hand] : LOSES[hand]

    { hand: hand, color: color, answer: answer }
  end
end
