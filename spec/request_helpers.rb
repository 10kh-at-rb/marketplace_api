module RequestHelpers
  def json_response
    @json_response ||= JSON.parse(response.body, symbolize_names: true)
  end

  def api_authorization_header(token)
    request.headers["Authorization"] = token
  end

  def api_header(version = 1)
    request.headers["Accept"] = "application/vnd.marketplace.v#{version}"
  end

  def api_response_format(format = Mime::JSON)
    request.headers["Accept"] = "#{request.headers["Accept"]}, #{format}"
    request.headers["Content-Type"] = format.to_s
  end

  def include_default_accept_headers
    api_header
    api_response_format
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :controller
  config.before(:example, type: :controller) do
    include_default_accept_headers
  end
end
