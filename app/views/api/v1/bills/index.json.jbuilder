json.array!(@bills) do |bill|
  json.extract! bill, :id, :type, :position, :title, :short_title
  json.url api_v1_bill_url(bill, format: :json)
  json.pdf bill_url(bill, format: :pdf, subdomain: 'www')
end
