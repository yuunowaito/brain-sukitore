require "test_helper"

class QuestionGeneratorTest < ActiveSupport::TestCase
  test "問題が生成される" do
    result = QuestionGenerator.generate
    assert result[:text].present?
    assert result[:answer].is_a?(Integer)
    assert_equal 4, result[:choices].size
  end

  test "正解が選択肢に含まれる" do
    result = QuestionGenerator.generate
    assert_includes result[:choices], result[:answer]
  end

  test "選択肢に重複がない" do
    result = QuestionGenerator.generate
    assert_equal result[:choices].size, result[:choices].uniq.size
  end

  test "答えがマイナスにならない" do
    20.times do
      result = QuestionGenerator.generate
      assert result[:answer] >= 0
    end
  end

  test "数字が3つまたは4つ使われる" do
    20.times do
      result = QuestionGenerator.generate
      word_count = result[:text].split(" ").size
      # 数字3つ→「A op B op C」= 5単語
      # 数字4つ→「A op B op C op D」= 7単語
      assert_includes [5, 7], word_count
    end
  end
end