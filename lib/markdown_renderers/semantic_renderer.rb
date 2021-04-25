module MarkdownRenderers
  class SemanticRenderer < Redcarpet::Render::HTML
    def header(text, header_level)
      # Prevent headers greater than level 3
      header_level = 3 if header_level < 3
      %(<h#{header_level} class='ui header'>#{text}</h#{header_level}>)
    end

    def hrule
      %(<hr class='ui divider' />)
    end
  end
end
