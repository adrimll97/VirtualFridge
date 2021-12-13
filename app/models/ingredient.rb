# frozen_string_literal: true

class Ingredient < ApplicationRecord
  mount_uploader :image, ImageUploader
end
