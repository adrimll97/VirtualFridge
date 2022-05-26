# frozen_string_literal: true

module ShowDeleteable
  extend ActiveSupport::Concern

  def delete_from_show?(show_path)
    request.referer.split('/').last(2) == show_path.split('/').last(2)
  end
end
