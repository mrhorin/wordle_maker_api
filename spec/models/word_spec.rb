require 'rails_helper'

RSpec.describe Word, type: :model do

  describe '#valid?' do
    context 'name' do
      subject{
        user = User.create(name: 'hoge', nickname: 'hogeuser', provider: 'twitter', image: 'https://fuga.com/hoge.jpg', uid: '1234567890')
        game = user.games.create(title: 'Pokemon Gen 1', lang: lang, char_count: char_count)
        word = game.words.new
        word.name = name
        word.valid?
      }

      context 'lang: "en", char_count: 5 の時' do
        let(:lang){ 'en' }
        let(:char_count){ 5 }

        context 'nil の時' do
          let(:name){ nil }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context '空文字列 の時' do
          let(:name){ '' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context '12345 の時' do
          let(:name){ 12345 }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウツー の時' do
          let(:name){ 'ミュウツー' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'サンドパン の時' do
          let(:name){ 'サンドパン' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'Mew の時' do
          let(:name){ 'Mew' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'Mewtwo の時' do
          let(:name){ 'Mewtwo' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'arbo2 の時' do
          let(:name){ 'arbo2' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'Arbok の時' do
          let(:name){ 'Arbok' }
          it('ture を返す'){ is_expected.to be_truthy }
        end

        context 'arbok の時' do
          let(:name){ 'arbok' }
          it('ture を返す'){ is_expected.to be_truthy }
        end

        context 'ARBOK の時' do
          let(:name){ 'ARBOK' }
          it('ture を返す'){ is_expected.to be_truthy }
        end
      end

      context 'lang: "ja", char_count: 5 の時' do
        let(:lang){ 'ja' }
        let(:char_count){ 5 }

        context 'nil の時' do
          let(:name){ nil }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context '空文字列 の時' do
          let(:name){ '' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context '12345 の時' do
          let(:name){ 12345 }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ARBOK の時' do
          let(:name){ 'ARBOK' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウ の時' do
          let(:name){ 'ミュウ' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウツー の時' do
          let(:name){ 'ミュウツー' }
          it('true を返す'){ is_expected.to be_truthy }
        end

        context 'ミュウツ− の時' do
          let(:name){ 'ミュウツ−' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウツ- の時' do
          let(:name){ 'ミュウツ-' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウツ、 の時' do
          let(:name){ 'ミュウツ、' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ミュウツ〜 の時' do
          let(:name){ 'ミュウツ〜' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'サンドパン の時' do
          let(:name){ 'サンドパン' }
          it('true を返す'){ is_expected.to be_truthy }
        end

        context 'サンドパN の時' do
          let(:name){ 'サンドパN' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'サンドパンパン の時' do
          let(:name){ 'サンドパンパン' }
          it('false を返す'){ is_expected.to be_falsey }
        end

        context 'ｻﾝﾄﾞﾊﾟﾝ の時' do
          let(:name){ 'ｻﾝﾄﾞﾊﾟﾝ' }
          it('false を返す'){ is_expected.to be_falsey }
        end
      end
    end
  end
end
