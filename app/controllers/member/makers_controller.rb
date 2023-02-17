class Member::MakersController < Member::MemberController
  def list
    @maker = Maker.all.order(order: :asc)
  end
end
