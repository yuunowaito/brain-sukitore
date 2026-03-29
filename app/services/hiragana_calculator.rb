class HiraganaCalculator
  HIRAGANA_TO_NUMBER = {
    "ぜろ"   => 0,
    "いち"   => 1,
    "に"     => 2,
    "さん"   => 3,
    "よん"   => 4,
    "ご"     => 5,
    "ろく"   => 6,
    "なな"   => 7,
    "はち"   => 8,
    "きゅう" => 9
  }.freeze

  HIRAGANA_TO_OPERATOR = {
    "たす"   => "+",
    "ひく"   => "-",
    "かける" => "*",
    "わる"   => "/"
  }.freeze

  def self.convert(hiragana)
    HIRAGANA_TO_NUMBER[hiragana.to_s.strip]
  end

  def self.convert_operator(hiragana)
    HIRAGANA_TO_OPERATOR[hiragana.to_s.strip]
  end

  def self.number_to_hiragana(number)
    HIRAGANA_TO_NUMBER.key(number)
  end
end
