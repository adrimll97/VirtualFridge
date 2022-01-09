# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :fridge, dependent: :destroy
  has_many :fridge_ingredients, through: :fridge

  validates :name, presence: true
  validates :name, uniqueness: true
end
