class ApplicationController < ActionController::Base
  before_action :set_current_user
  before_action :set_active_storage_host

  # Bit of convenience for partials.  Adds an additional, less efficient resolver
  # That will look for partials in a subfolder named "partials".  This could be
  # expanded to do a folder glob (**) instead of specifying the "partials" folder.
  # This would give us a little more freedom in grouping partials
  append_view_path(
    ActionView::FileSystemResolver.new(view_paths.first.to_s).tap do |resolver|
      resolver.instance_variable_set('@pattern', ActionView::PathResolver::DEFAULT_PATTERN.sub(':prefix', ':prefix{/partials,}'))
    end
  )

  def set_current_user
    Current.user = current_user
  end

  def set_active_storage_host
    ActiveStorage::Current.host = request.url
  end

  def current_ability
    Current.ability || Ability.new
  end

end
