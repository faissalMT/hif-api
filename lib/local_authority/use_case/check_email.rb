# frozen_string_literal: true

class LocalAuthority::UseCase::CheckEmail
  def initialize(email_whitelist_gateway:)
    @email_whitelist_gateway = email_whitelist_gateway
  end

  def execute(email_address:)
    returned_id = @email_whitelist_gateway.find_by(email_address)
    { valid: !returned_id.nil? }
  end
end
