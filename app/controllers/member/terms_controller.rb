class Member::TermsController < Member::MemberController
  def index
    @term = Term.where('effective_date <= ?', DateTime.now).where(terms_purpose: :to_customer).order(effective_date: :desc).first
  end
end
