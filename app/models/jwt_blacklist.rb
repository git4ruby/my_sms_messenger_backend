class JwtBlacklist
  include Mongoid::Document
  include Mongoid::Timestamps

  field :jti, type: String
  field :exp, type: Time

  index({ jti: 1 }, { unique: true })

  def self.jwt_revoked?(payload, user)
    exists?(jti: payload['jti'])
  end

  def self.revoke_jwt(payload, user)
    create!(jti: payload['jti'], exp: Time.at(payload['exp']))
  end
end