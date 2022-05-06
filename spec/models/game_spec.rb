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

      context '2byte x 101文字 の時' do
        let(:hash){
          title = ''
          101.times{|i| title += 'あ'}
          {title: title, lang: 'ja', char_count: 5}
        }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context '2byte x 100文字 の時' do
        let(:hash){
          title = ''
          100.times{|i| title += 'あ'}
          {title: title, lang: 'ja', char_count: 5}
        }
        it('true を返す'){ is_expected.to be_truthy }
      end
    end

    context 'desc' do
      context 'nil の時' do
        let(:hash){ {title: 'Pokemon Gen 1', desc: nil, lang: 'en', char_count: 5} }
        it('false を返す'){ is_expected.to be_truthy }
      end

      context '2byte x 200文字 の時' do
        let(:hash){
          desc = ''
          200.times{|i| desc += 'あ'}
          {title: 'Pokemon Gen 1', desc: desc, lang: 'en', char_count: 5}
        }
        it('false を返す'){ is_expected.to be_truthy }
      end

      context '2byte x 201文字 の時' do
        let(:hash){
          desc = ''
          201.times{|i| desc += 'あ'}
          {title: 'Pokemon Gen 1', desc: desc, lang: 'en', char_count: 5}
        }
        it('true を返す'){ is_expected.to be_falsey }
      end

      context '1byte x 201文字 の時' do
        let(:hash){
          desc = ''
          201.times{|i| desc += 'A'}
          {title: 'Pokemon Gen 1', desc: desc, lang: 'en', char_count: 5}
        }
        it('true を返す'){ is_expected.to be_falsey }
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

    context 'challenge_count' do
      context '1 の時' do
        let(:hash){ {title: 'あいうえお', lang: 'ja', char_count: 4, challenge_count: 1} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context '11 の時' do
        let(:hash){ {title: 'あいうえお', lang: 'ja', char_count: 4, challenge_count: 11} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context 'A の時' do
        let(:hash){ {title: 'あいうえお', lang: 'en', char_count: 4, challenge_count: 'A'} }
        it('false を返す'){ is_expected.to be_falsey }
      end

      context '2 の時' do
        let(:hash){ {title: 'あいうえお', lang: 'en', char_count: 4, challenge_count: 2} }
        it('true を返す'){ is_expected.to be_truthy }
      end

      context '10 の時' do
        let(:hash){ {title: 'あいうえお', lang: 'en', char_count: 4, challenge_count: 10} }
        it('true を返す'){ is_expected.to be_truthy }
      end
    end
  end

end
