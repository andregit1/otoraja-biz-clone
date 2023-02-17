json.array!(@tech_specs) do |tech_spec|
  json.id(tech_spec.id)
  json.name(tech_spec.name)
end
