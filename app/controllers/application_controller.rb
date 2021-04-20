class ApplicationController < ActionController::Base

  # Bit of convenience for partials.  Adds an additional, less efficient resolver
  # That will look for partials in a subfolder named "partials".  This could be
  # expanded to do a folder glob (**) instead of specifying the "partials" folder.
  # This would give us a little more freedom in grouping partials
  append_view_path(
    ActionView::FileSystemResolver.new(view_paths.first.to_s).tap do |resolver|
      resolver.instance_variable_set('@pattern', ActionView::PathResolver::DEFAULT_PATTERN.sub(':prefix', ':prefix{/partials,}'))
    end
  )

end
