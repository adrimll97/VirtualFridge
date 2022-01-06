# frozen_string_literal: true

class MySessionController < Devise::SessionsController
  def new
    self.resource = resource_class.new(sign_in_params)
    clean_up_passwords(resource)
    yield resource if block_given?
    respond_to do |format|
      format.js { render 'devise/sessions/new.js.erb' }
    end
  end
end
