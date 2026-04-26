require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'バリデーション' do
    it '有効なファクトリを持つこと' do
      expect(build(:profile)).to be_valid
    end

    it 'nameがないと無効' do
      expect(build(:profile, name: nil)).to be_invalid
    end
  end
end
