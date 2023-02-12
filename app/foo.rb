class Foo
  # 半角数字7桁の文字列かどうかを判定する
  def self.valid_postcode?(postcode)
    return false unless postcode.is_a?(String)

    /\A\d{7}\z/.match?(postcode)
  end
end
