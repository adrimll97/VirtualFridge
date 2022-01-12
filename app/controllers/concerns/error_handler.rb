# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    def error_js(errors)
      @errors = errors.is_a?(Array) ? errors : [errors]
      respond_to do |format|
        format.js { render 'shared/error_js' }
      end
    end
  end
end
