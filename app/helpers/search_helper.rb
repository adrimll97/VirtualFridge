module SearchHelper
  def search_value
    return params['search'] if params['search'].present?

    ''
  end
end
