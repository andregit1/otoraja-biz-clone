json.array! @mechanic_summary.each_with_index.to_a do |mechanic, index|
  json.no index + 1
  json.merge! mechanic
end
