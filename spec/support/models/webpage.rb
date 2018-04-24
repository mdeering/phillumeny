# frozen_string_literal: true

require 'active_model'

class Webpage

  include ActiveModel::Validations

  attr_accessor :body
  attr_accessor :headline
  attr_accessor :title

  validates :body,
            presence: true

  validates :headline,
            presence: true,
            unless: -> { title.present? }

  validates :title,
            presence: true,
            inclusion: { allow_blank: true, in: ['this'] },
            unless: -> { headline.present? && headline != 'needs title' }
end
