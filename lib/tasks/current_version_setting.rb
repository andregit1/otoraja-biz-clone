class CurrentVersionSetting
  def self.execute
    version = ARGV[0]
    File.open("#{Rails.root}/app/views/layouts/_current_version.html.erb", 'w') do |f| 
      f.puts("#{version}")
    end
    File.open("#{Rails.root}/app/views/layouts/_current_version.jbuilder", 'w') do |f| 
      f.puts("json.ver '#{version}'")
    end
  end
end

CurrentVersionSetting.execute
