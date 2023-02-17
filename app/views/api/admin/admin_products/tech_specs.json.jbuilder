@tech_specs.each do |tech_spec|
    json.set! tech_spec.id, tech_spec.name
end