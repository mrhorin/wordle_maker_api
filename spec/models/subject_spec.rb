require 'rails_helper'

RSpec.describe Subject, type: :model do

  describe '#valid?' do
    subject{
      user = User.create(name: 'hoge', nickname: 'hogeuser', provider: 'twitter', image: 'https://fuga.com/hoge.jpg', uid: '1234567890')
      game = user.games.create(title: 'あいうえお', lang: 'en', char_count: 5)
      subject = game.subjects.new
      subject.attributes = hash
      subject.valid?
    }

    context 'word' do
      context 'nil の時' do
        let(:hash){ {word: nil} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context '空文字列 の時' do
        let(:hash){ {word: ''} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context 'ミュウ(文字数がgame.char_countとより少ない) の時' do
        let(:hash){ {word: 'ミュウ'} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context 'メタルグレイモン(文字数がgame.char_countとより多い) の時' do
        let(:hash){ {word: 'メタルグレイモン'} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context 'リザードン(文字数がgame.char_countと一致) の時' do
        let(:hash){ {word: 'リザードン'} }
        it('ture を返す'){ is_expected.to be_truthy }
      end

      context '12345 の時' do
        let(:hash){ {word: 12345} }
        it('ture を返す'){ is_expected.to be_truthy }
      end
    end
  end

end
