class AddColumnToCustomersAndTerms < ActiveRecord::Migration[5.2]
  def change
    add_column :terms, :terms_purpose, :int, :after => :effective_date, null: false
    add_column :customers, :mypage_terms_agreed_at, :datetime, :after => :terms_agreed_at, null: true
    Term.reset_column_information
    term = Term.first
    Term.create(
      terms: term.terms,
      effective_date: term.effective_date,
      terms_purpose: :to_customer
    )
    term.update(terms_purpose: :to_bengkel)
  end
end
