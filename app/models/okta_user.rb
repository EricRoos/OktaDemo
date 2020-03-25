class OktaUser < User
  def self.find_or_create_by_source_identifier(identifier)
    user = OktaUser.where(source_identifier: identifier).first
    if !user
      user = OktaUser.create(source_identifier: identifier, password: SecureRandom.hex(64))
    end
    return user
  end
end
