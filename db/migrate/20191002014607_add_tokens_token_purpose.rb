class AddTokensTokenPurpose < ActiveRecord::Migration[5.2]
  def change
    add_column :tokens, :token_purpose, :integer, null: false, :after => 'uuid'
    add_index :tokens, :uuid
    Token.all.each do |token|
      token.update(token_purpose: :questionnaire)
    end
  end
end
