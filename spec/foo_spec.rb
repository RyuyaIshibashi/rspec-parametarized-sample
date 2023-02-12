require_relative '../app/foo'

RSpec.describe Foo do

  describe '.valid_postcode?'do

    context "Dryだけどリーダブルではないテスト" do
      [
        ['1234567', true],
        ['12345678', false],
        [1234567, false],
      ].each do |postcode, expected|
        it "#{postcode}の場合、#{expected}を返すこと"do
            expect(described_class.valid_postcode?(postcode)).to eq expected
        end
      end
    end

    context '上記をリーダブルに改めたテスト'do
      it "半角数字７桁の文字列の場合、trueを返すこと" do
          expect(described_class.valid_postcode?('1234567')).to eq true
      end

      it "半角数字8桁の文字列の場合、falseを返すこと" do
          expect(described_class.valid_postcode?('12345678')).to eq false
      end

      it "７桁の数値の場合、falseを返すこと" do
          expect(described_class.valid_postcode?(1234567)).to eq false
      end
    end

    context 'リーダブルではないテストの長いバージョン'do
      [
        ['1234567', true],
        ['0123456', true],
        ['123 4567', false],
        ['123456', false],
        ['12345678', false],
        ['123.456', false],
        ['123456a', false],
        [1234567, false],
      ].each do |postcode, expected|
          it "#{postcode}の場合、#{expected}を返すこと"do
              expect(described_class.valid_postcode?(postcode)).to eq expected
          end
      end
    end

    context 'リーダブルにすると冗長になってしまう' do
      it "半角数字７桁の文字列の場合、trueを返すこと" do
          expect(described_class.valid_postcode?('1234567')).to eq true
      end

      it "0始まりの半角数字7桁の文字列の場合、trueを返すこと" do
          expect(described_class.valid_postcode?('0123456')).to eq true
      end

      it "間にスペースが含まれる文字列の場合、falseを返すこと" do
          expect(described_class.valid_postcode?('123 4567')).to eq false
      end

      it "半角数字6桁の文字列の場合、falseを返すこと" do
          expect(described_class.valid_postcode?('123456')).to eq false
      end

      it "半角数字8桁の文字列の場合、falseを返すこと" do
          expect(described_class.valid_postcode?('12345678')).to eq false
      end

      it "小数として扱える文字列の場合、falseを返すこと" do
          expect(described_class.valid_postcode?('123.456')).to eq false
      end

      it "半角数字以外が含まれる文字列の場合、falseを返すこと" do
          expect(described_class.valid_postcode?('123456a')).to eq false
      end

      it "７桁の数値の場合、falseを返すこと" do
          expect(described_class.valid_postcode?(1234567)).to eq false
      end
    end

    context "コメントやインデントを活用した改善案" do
      shared_examples 'test valid_postcode?' do |input, expected, description|
        it "#{description}の場合、#{expected}を返すこと"do
            expect(described_class.valid_postcode?(input)).to eq expected
        end
      end

      testcases =
          [
          # [入力値,       期待値,  説明]
            ['1234567',   true,  '半角数字７桁の文字列'],
            ['0123456',   true,  '0始まりの半角数字7桁の文字列'],
            ['123 4567',  false, '間にスペースが含まれる文字列'],
            ['123456',    false, '半角数字6桁の文字列'],
            ['12345678',  false, '半角数字8桁の文字列'],
            ['123.456',   false, '小数として扱える文字列'],
            ['123456a',   false, '半角数字以外が含まれる文字列'],
            [1234567,     false, '７桁の数値'],
          ]

      testcases.each { it_behaves_like "test valid_postcode?", _1, _2, _3 }
    end

    context "rspec-parameterizedを用いた改善案" do
      using RSpec::Parameterized::TableSyntax

      where(:input, :expected, :description) do
      # 入力値      | 期待値 | 説明
        '1234567'  | true  | '半角数字７桁の文字列'
        '0123456'  | true  | '0始まりの半角数字7桁の文字列'
        '123 4567' | false | '間にスペースが含まれる文字列'
        '123456'   | false | '半角数字6桁の文字列'
        '12345678' | false | '半角数字8桁の文字列'
        '123.456'  | false | '小数として扱える文字列'
        '123456a'  | false | '半角数字以外が含まれる文字列'
        1234567    | false | '７桁の数値'
      end

      with_them do
        it "#{params[:description]}の場合、#{params[:expected]}を返すこと" do
          expect(described_class.valid_postcode?(input)).to eq expected
        end
      end
    end
  end
end
