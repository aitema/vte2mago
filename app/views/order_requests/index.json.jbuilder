json.array!(@order_requests) do |order_request|
  json.extract! order_request, :id
  json.url order_request_url(order_request, format: :json)
end
