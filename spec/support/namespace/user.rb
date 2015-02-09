require 'active_model'

module Namespace
  class User

    include ActiveModel::Validations

    attr_accessor :username

    validates :username,
      presence: true

  end
end
