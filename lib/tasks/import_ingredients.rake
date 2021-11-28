# frozen_string_literal: true

require 'csv'

MULTIPLICATION_REGEX = /^\d+\s*x\s*\d+/
FIRST_NUMBER_REGEX = /^[\d.,]+/
LAST_NUMBER_REGEX = /[\d.,]+$/
UNITS_REGEX = /([a-wyzA-WYZ]+)/
UNITS = {
  kg: %w[kg k kgrs kilos],
  g: %w[g gr gm gms grs grm grms gramos grammes grams neto],
  mg: %w[mg],
  mcg: %w[mcg],
  lb: %w[lb lbs],
  l: %w[l lt ltr lts litro litros litre litres],
  cl: %w[cl dl ck cc],
  ml: %w[ml mi m],
  oz: %w[oz o fl],
  ud: %w[ud u un uds und unid unidad unidades unit units tablet tablets pieza piezas barritas sobres bolsa
         bolsas pastillas sticks pots paquetes tazas bolsitas c capsulas capsules pack tarros manojo rebanadas
         comprimidos huevos barras bricks porciones planta ufs galetes cabezas cu dose cubes]
}.freeze

namespace :ingredients do
  desc 'Import ingredients from openfoodfacts public database'
  task import: :environment do
    ingredients = []
    path = ENV['CSV_PATH']
    abort 'It is necessary to specify the path of the csv' if path.blank?

    CSV.foreach(path, headers: true, col_sep: "\t", quote_char: "\x00") do |row|
      contry = row['countries_en']
      next unless contry == 'Spain'

      name = row['product_name']
      next if name.blank? || ingredients.include?(name)

      quantity = row['quantity']
      next if quantity.blank?

      quantity_number = get_quantity_number(quantity)
      quantity_unit = get_quantity_unit(quantity)
      next if quantity_number.blank? || quantity_unit.blank?

      url = row['url']
      image_url = row['image_small_url']

      Ingredient.create(
        {
          name: name,
          url: url,
          image_url: image_url,
          quantity_number: quantity_number,
          quantity_unit: quantity_unit
        }
      )
      ingredients << name
    end
  end

  def get_quantity_number(quantity)
    multiplication = quantity.match(MULTIPLICATION_REGEX)

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
    quantity_string.gsub(',', '.').to_f
  end

  def get_quantity_unit(quantity)
    quantity_unit = quantity.match(UNITS_REGEX)
    quantity_unit.present? ? parse_quantity_unit(quantity_unit[0].downcase) : nil
  end

  def parse_quantity_unit(unit)
    final_unit = nil
    UNITS.each do |key, values|
      final_unit = key.to_s if values.include? unit
    end
    final_unit
  end
end
