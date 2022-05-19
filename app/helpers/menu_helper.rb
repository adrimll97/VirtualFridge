# frozen_string_literal: true

module MenuHelper
  def self_menu?(menu)
    menu.user_id == current_user&.id
  end
end
