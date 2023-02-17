json.answer_choices do
  json.positive_choice do
    json.array! @positive_choice, :id, :export_id, :choice
  end
  json.negative_choice do
    json.array! @negative_choice, :id, :export_id, :choice
  end
  json.visiting_reasons do
    json.array! @visiting_reasons, :id, :name
  end
end
