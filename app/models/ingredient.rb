# frozen_string_literal: true

class Ingredient < ApplicationRecord
  mount_uploader :image, ImageUploader

  default_scope { order(:name) }
end
