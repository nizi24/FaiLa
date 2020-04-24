module MarkdownHelper
  def markdown(text)
    unless @markdown
      options = {
        hard_wrap: true,
        safe_links_only: true
      }
      extensions = {
        no_intra_emphasis: true,
        tables: true,
        autolink: true,
        quote: true,
        highlight: true,
        strikethrough: true,
        fenced_code_blocks: true,
        superscript: true,
        footnotes: true
      }
      renderer = Redcarpet::Render::HTML.new(options)
      @markdown = Redcarpet::Markdown.new(renderer, extensions)
    end

    @markdown.render(text).html_safe
  end
end
