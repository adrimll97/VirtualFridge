# frozen_string_literal: true

namespace :ingredients do
  task import_images: :environment do
    Ingredient.all.find_each do |ingredient|
      next if ingredient.image.file.present?

      image_url = ingredient['image_url']
      next if image_url.blank?

      begin
        ingredient.remote_image_url = image_url
        ingredient.save!
        p "Completed #{ingredient.name}"
      rescue ActiveRecord::RecordInvalid => _e
        p "Failed #{ingredient.name}"
        next
      end
    end
  end
end
