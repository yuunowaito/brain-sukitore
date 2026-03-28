require "test_helper"

class HiraganaCalculatorTest < ActiveSupport::TestCase
  test "有効なひらがなを数字に変換できる" do
    assert_equal 0, HiraganaCalculator.convert("ぜろ")
    assert_equal 1, HiraganaCalculator.convert("いち")
    assert_equal 9, HiraganaCalculator.convert("きゅう")
  end

  test "無効なひらがなはnilを返す" do
    assert_nil HiraganaCalculator.convert("ほげ")
  end

  test "ひらがなを演算子に変換できる" do
    assert_equal "+", HiraganaCalculator.convert_operator("たす")
    assert_equal "-", HiraganaCalculator.convert_operator("ひく")
    assert_equal "*", HiraganaCalculator.convert_operator("かける")
    assert_equal "/", HiraganaCalculator.convert_operator("わる")
  end

  test "無効なひらがなはnilを返す（演算子）" do
    assert_nil HiraganaCalculator.convert_operator("ほげ")
  end
end
