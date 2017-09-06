require 'jwt'

class Auth

  ALGORITHM = 'HS256'

  def self.issue(payload, exp)
    payload[:exp] = exp
    JWT.encode(payload, auth_secret, 'HS256')
  end

  def self.decode(token)
    JWT.decode(token, auth_secret, true, {algorithm: 'HS256'}).first
  rescue
    return nil
  end

  def self.auth_secret
    ENV["AUTH_SECRET"]
  end

end
