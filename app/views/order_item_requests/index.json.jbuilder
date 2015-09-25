json.array!(@order_item_requests) do |order_item_request|
  json.extract! order_item_request, :id
  json.url order_item_request_url(order_item_request, format: :json)
end
