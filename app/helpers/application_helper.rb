module ApplicationHelper
  def markdown(text)
    markdown_renderer.render(text).html_safe
  end

  def variation_for_flash(level)
    case level
    when :error
      'error'
    when :alert
      'warning'
    when :notice
      'info'
    when :success
      'success'
    end
  end

  private

  def markdown_renderer
    @markdown_renderer ||= Redcarpet::Markdown.new(
      MarkdownRenderers::SemanticRenderer.new(no_images: true, no_styles: true, filter_html: true,
                                              link_attributes: { target: '_blank' }),
      no_intra_emphasis: true, strikethrough: true, superscript: true
    )
  end
end
