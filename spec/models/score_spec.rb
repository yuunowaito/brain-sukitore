require 'rails_helper'

RSpec.describe GameType, type: :model do
  describe 'バリデーション' do
    it '有効なファクトリを持つこと' do
      expect(build(:game_type)).to be_valid
    end

    it 'nameがないと無効' do
      expect(build(:game_type, name: nil)).to be_invalid
    end

    it 'nameが重複していると無効' do
      create(:game_type, name: 'hiragana')
      expect(build(:game_type, name: 'hiragana')).to be_invalid
    end

    it 'display_nameがないと無効' do
      expect(build(:game_type, display_name: nil)).to be_invalid
    end
  end
end