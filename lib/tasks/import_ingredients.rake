# frozen_string_literal: true

require 'csv'

MULTIPLICACION_REGEX = /^\d+\s*x\s*\d+/
FIRST_NUMBER_REGEX = /^[\d.,]+/
LAST_NUMBER_REGEX = /[\d.,]+$/
UNITS_REGEX = /([a-wyzA-WYZ]+)/

namespace :ingredients do
  desc 'Import ingredients from openfoodfacts public database'
  task :import do
    ingredients = []
    path = ENV['CSV_PATH']
    abort 'It is necessary to specify the path of the csv' if path.blank?

    CSV.foreach(path, headers: true, col_sep: "\t", quote_char: "\x00") do |row|
      contry = row['countries_en']
      next unless contry == 'Spain'

      name = row['product_name'] || row['brands']
      next if name.blank? || ingredients.include?(name)

      ingredients << name
      quantity = row['quantity']
      next if quantity.blank?

      quantity_number = get_quantity_number(quantity)
      quantity_unit = get_quantity_unit(quantity)

      if quantity_number.blank? || quantity_unit.blank?
        quantity_number = 1
        quantity_unit = 'ud'
      end
      url = row['url']
      image_url = row['image_small_url']
    end
  end

  def get_quantity_number(quantity)
    multiplication = quantity.match(MULTIPLICACION_REGEX)

    if multiplication
      first_number = parse_quantity_number(multiplication.to_s.match(FIRST_NUMBER_REGEX)[0])
      last_number = parse_quantity_number(multiplication.to_s.match(LAST_NUMBER_REGEX)[0])
      first_number * last_number
    else
      first_number = quantity.match(FIRST_NUMBER_REGEX)
      first_number.present? ? parse_quantity_number(first_number[0]) : nil
    end
  end

  def parse_quantity_number(quantity_string)
    return quantity_string.gsub(',', '.').to_f if quantity_string.include?(',') || quantity_string.include?('.')

    quantity_string.to_i
  end

  def get_quantity_unit(quantity)
    quantity_unit = quantity.match(UNITS_REGEX)
    quantity_unit.present? ? quantity_unit[0] : nil
  end
end
