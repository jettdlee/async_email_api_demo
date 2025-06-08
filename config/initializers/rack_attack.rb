class Rack::Attack
  throttle('limit_uploads', limit: 10, period: 60) do |req|
    req.ip if req.path == '/upload' && req.post?
  end
end
