class StaticController < ApplicationController
  def about
    @compact_view = true
  end

  def terms_of_service
    @compact_view = true
  end

  def privacy_policy
    @compact_view = true
  end

  def page_title
    action_name.titleize
  end
end
