json.topics do
  json.array! @topics, partial: 'info', as: :topic
end
