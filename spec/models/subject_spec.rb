require 'rails_helper'

RSpec.describe Subject, type: :model do

  describe '#valid?' do
    context 'word' do
      subject{
        user = User.create(name: 'hoge', nickname: 'hogeuser', provider: 'twitter', image: 'https://fuga.com/hoge.jpg', uid: '1234567890')
        game = user.games.create(title: 'Pokemon Gen 1', lang: lang, char_count: char_count)
        subject = game.subjects.new
        subject.word = word
        subject.valid?
      }

      context 'lang: "en", char_count: 5 の時' do
        let(:lang){ 'en' }
        let(:char_count){ 5 }

        context 'nil の時' do
          let(:word){ nil }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context '空文字列 の時' do
          let(:word){ '' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context '12345 の時' do
          let(:word){ 12345 }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウツー の時' do
          let(:word){ 'ミュウツー' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'サンドパン の時' do
          let(:word){ 'サンドパン' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'Mew の時' do
          let(:word){ 'Mew' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'Mewtwo の時' do
          let(:word){ 'Mewtwo' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'arbo2 の時' do
          let(:word){ 'arbo2' }
          it('ture を返す'){ is_expected.to be_falsey }
        end

        context 'Arbok の時' do
          let(:word){ 'Arbok' }
          it('ture を返す'){ is_expected.to be_truthy }
        end

        context 'arbok の時' do
          let(:word){ 'arbok' }
          it('ture を返す'){ is_expected.to be_truthy }
        end

        context 'ARBOK の時' do
          let(:word){ 'ARBOK' }
          it('ture を返す'){ is_expected.to be_truthy }
        end
      end

      context 'lang: "ja", char_count: 5 の時' do
        let(:lang){ 'ja' }
        let(:char_count){ 5 }

        context 'nil の時' do
          let(:word){ nil }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context '空文字列 の時' do
          let(:word){ '' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context '12345 の時' do
          let(:word){ 12345 }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ARBOK の時' do
          let(:word){ 'ARBOK' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウ の時' do
          let(:word){ 'ミュウ' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウツー の時' do
          let(:word){ 'ミュウツー' }
          it('true を返す'){ is_expected.to be_truthy }
        end

        context 'ミュウツ− の時' do
          let(:word){ 'ミュウツ−' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウツ- の時' do
          let(:word){ 'ミュウツ-' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウツ、 の時' do
          let(:word){ 'ミュウツ、' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウツ〜 の時' do
          let(:word){ 'ミュウツ〜' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'サンドパン の時' do
          let(:word){ 'サンドパン' }
          it('true を返す'){ is_expected.to be_truthy }
        end

        context 'サンドパN の時' do
          let(:word){ 'サンドパN' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'サンドパンパン の時' do
          let(:word){ 'サンドパンパン' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ｻﾝﾄﾞﾊﾟﾝ の時' do
          let(:word){ 'ｻﾝﾄﾞﾊﾟﾝ' }
          it('false を返す'){ is_expected.to be_falsey }
        end
      end
    end
  end
end
