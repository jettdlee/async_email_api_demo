class Rack::Attack
  throttle("limit uploads", limit: 10, period: 60.seconds) do |req|
    if req.path == "/upload" && req.post?
      req.ip
    end
  end

  self.throttled_responder = ->(_env) {
    [ 429, { "Content-Type" => "application/json" }, [ { error: "Rate limit exceeded" }.to_json ] ]
  }
end
