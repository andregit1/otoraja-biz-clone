json.token do
  json.extract! @token, :id, :uuid
  json.rate(@answers_rate&.rate)
end
