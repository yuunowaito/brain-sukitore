require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    it '有効なファクトリを持つこと' do
      expect(build(:user)).to be_valid
    end

    it 'emailがないと無効' do
      expect(build(:user, email: nil)).to be_invalid
    end

    it 'emailが重複していると無効' do
      create(:user, email: 'test@example.com')
      expect(build(:user, email: 'test@example.com')).to be_invalid
    end

    it 'passwordがないと無効' do
      expect(build(:user, password: nil)).to be_invalid
    end
  end
end