json.set! :backend_api do
  json.partial! partial: 'layouts/current_version'
end
json.set! :android do
  json.require_ver(@version&.android_require_version)
  json.latest_ver(@version&.android_latest_version)
end
json.set! :ios do
  json.require_ver(@version&.ios_require_version)
  json.latest_ver(@version&.ios_latest_version)
end
