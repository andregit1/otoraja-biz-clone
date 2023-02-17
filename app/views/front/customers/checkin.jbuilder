json.set! :all do
  json.partial! partial: 'checkin_record', locals: { checkins: @all_checkins }
end
json.set! :uncheckdout do
  json.partial! partial: 'checkin_record', locals: { checkins: @uncheckout_checkins }
end
json.set! :checkdout do
  json.partial! partial: 'checkin_record', locals: { checkins: @checkout_checkins }
end
