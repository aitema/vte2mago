json.array!(@company_requests) do |company_request|
  json.extract! company_request, :id
  json.url company_request_url(company_request, format: :json)
end
