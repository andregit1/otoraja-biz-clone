Rails.application.routes.draw do
  Dir.glob(File.expand_path("#{Rails.root}/config/routes/**/*.rb", __FILE__)).each do |file|
    instance_eval(File.read(file))
  end
end
