require 'rails_helper'

RSpec.describe Score, type: :model do
  describe 'バリデーション' do
    it '有効なファクトリを持つこと' do
      expect(build(:score)).to be_valid
    end

    it 'userがないと無効' do
      expect(build(:score, user: nil)).to be_invalid
    end

    it 'game_typeがないと無効' do
      expect(build(:score, game_type: nil)).to be_invalid
    end

    it 'scoreがないと無効' do
      expect(build(:score, score: nil)).to be_invalid
    end

    it 'scoreが0以上でないと無効' do
      expect(build(:score, score: -1)).to be_invalid
    end

    it 'played_onがないと無効' do
      expect(build(:score, played_on: nil)).to be_invalid
    end
  end
end
