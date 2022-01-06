# frozen_string_literal: true

module Devise
  class MyRegistrationController < Devise::RegistrationsController
    def new
      build_resource
      yield resource if block_given?
      respond_to do |format|
        format.js { render 'devise/sessions/new.js.erb' }
      end
    end
  end
end
