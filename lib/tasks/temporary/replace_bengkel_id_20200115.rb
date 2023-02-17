class ReplaceBengkelId20200115
  def self.execute
    Shop.find_each do |shop|
      shop.bengkel_id.sub!(/\AB/, '100')
      shop.save
    end
  end
end

ReplaceBengkelId20200115.execute
