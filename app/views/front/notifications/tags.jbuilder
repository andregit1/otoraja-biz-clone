json.array! @tags do |tag|
  json.merge! tag.attributes
end
