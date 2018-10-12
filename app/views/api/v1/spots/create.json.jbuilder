json.spot do
  json.partial! 'info', spot: @spot
end

json.matches @spot.matches, partial: 'match_info', as: :match if @spot.matches
