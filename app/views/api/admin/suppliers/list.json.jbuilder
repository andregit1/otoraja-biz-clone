@suppliers.each do |supplier|
  json.set! supplier.id, supplier.name
end