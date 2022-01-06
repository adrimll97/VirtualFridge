# frozen_string_literal: true

module Devise
  class MyPasswordsController < Devise::PasswordsController
    def new
      super
      respond_to do |format|
        format.js { render 'devise/passwords/new.js.erb' }
      end
    end
  end
end
