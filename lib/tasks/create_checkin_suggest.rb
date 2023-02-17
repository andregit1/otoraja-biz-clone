class CreateCheckinSuggest
  def self.execute
    if ARGV[0] == 'create_index'
      p 'start create_index'
      Customer.create_index!
      p 'end create_index'
    end
    p 'start data import'
    count = Customer.__elasticsearch__.import
    p "end data import #{count}"
  end
end

CreateCheckinSuggest.execute
