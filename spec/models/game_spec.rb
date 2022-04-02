require 'rails_helper'

RSpec.describe Game, type: :model do

  describe '#valid?' do
    subject{
      user = User.create(name: 'hoge', nickname: 'hogeuser', provider: 'twitter', image: 'https://fuga.com/hoge.jpg', uid: '1234567890')
      game = user.games.new
      game.attributes = hash
      game.valid?
    }

    context 'title' do
      context 'nil の時' do
        let(:hash){ {title: nil, lang: 'ja', char_count: 5} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context '21文字 の時' do
        let(:hash){ {title: 'あいうえおかきくけこさしすせそなにぬねのた', lang: 'ja', char_count: 5} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context '20文字 の時' do
        let(:hash){ {title: 'あいうえおかきくけこさしすせそなにぬねの', lang: 'ja', char_count: 5} }
        it('true を返す'){ is_expected.to be_truthy }
      end
    end

    context 'lang' do
      context 'jpn の時' do
        let(:hash){ {title: 'あいうえお', lang: 'jpn', char_count: 5} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context '英語 の時' do
        let(:hash){ {title: 'あいうえお', lang: '英語', char_count: 5} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context 'fr の時' do
        let(:hash){ {title: 'あいうえお', lang: 'fr', char_count: 5} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context 'en の時' do
        let(:hash){ {title: 'あいうえお', lang: 'en', char_count: 5} }
        it('true を返す'){ is_expected.to be_truthy }
      end
    end

    context 'char_count' do
      context '1 の時' do
        let(:hash){ {title: 'あいうえお', lang: 'ja', char_count: 1} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context '11 の時' do
        let(:hash){ {title: 'あいうえお', lang: 'ja', char_count: 11} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context 'A の時' do
        let(:hash){ {title: 'あいうえお', lang: 'en', char_count: 'A'} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context '2 の時' do
        let(:hash){ {title: 'あいうえお', lang: 'en', char_count: 2} }
        it('true を返す'){ is_expected.to be_truthy }
      end

      context '10 の時' do
        let(:hash){ {title: 'あいうえお', lang: 'en', char_count: 10} }
        it('true を返す'){ is_expected.to be_truthy }
      end
    end
  end

end