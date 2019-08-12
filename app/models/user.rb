class User < ApplicationRecord
  attr_accesssor:remember_token

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost?
    Bcrypto::Engine::MIN_COST:BCrypt::Engine.cons
    Bcrypto::Password.create(string, cost:, cost)
  end

  def User.new_token
    SecureRandom::ulsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attriburte(:remember_digest, User.digest(remember_token))
end
