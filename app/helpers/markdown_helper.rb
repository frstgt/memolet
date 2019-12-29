module MarkdownHelper
  require 'redcarpet'
  require 'rouge'
  require 'rouge/plugins/redcarpet'
  require 'csv'

  class MyRender < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet

    def is_yutube_link?(link)
      if link =~ /https\:\/\/www\.youtube\.com\/watch\?v\=([\w\-\_]+)/
        $1
      elsif link =~ /https\:\/\/youtu\.be\/([\w\-\_]+)/
        $1
      else
        nil
      end
    end
    def yutube_embed_link(id)
      "<iframe width=\"517\" height=\"291\" src=\"https://www.youtube.com/embed/#{id}\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>"
    end

    def link(link, title, content)
      link = CGI::escapeHTML(link)
      if id = is_yutube_link?(link)
        yutube_embed_link(id) # ignore title and content
      else
        "<a href=\"#{link}\" title=\"#{title}\">#{content}</a>"
      end
    end
    def autolink(link, link_type)
      link = CGI::escapeHTML(link)
      if id = is_yutube_link?(link)
        yutube_embed_link(id)
      else
        "<a href=\"#{link}\">#{link}</a>"
      end
    end

    def table_html(code)
      code.gsub!(/^\{(.*)\}\n*/m, "")
      css = $1.split(/,/) if $1
      table_style = (css && css[0]) ? css[0] : ""
      th_style = (css && css[1]) ? css[1] : ""
      td_styles = (css && css[2..css.length]) ? css[2..css.length] : []

      begin
        data = CSV.parse(code)

        head_data = data[0]
        body_data = data[1..data.length]

        html_str = "<table style=\"#{table_style}\"><thead><tr>"

        head_data.each do |cell|
          html_str += "<th style=\"#{th_style}\">#{cell.strip}</th>"
        end
        html_str += "</tr></thead><tbody>"

        body_data.each do |row|
          html_str += "<tr>"
          row.each_with_index do |cell, i|
            td_style = (td_styles[i]) ? td_styles[i] : ""
            html_str += "<td style=\"#{td_style}\">#{cell.strip}</td>"
          end
          html_str += "</tr>"
        end

        html_str += "</tbody></table>"
      rescue
        ""
      end
    end

    def block_code(code, language)
      if language=="mathjax"
        "<script type=\"math/tex; mode=display\">\n#{code}\n</script>"
      elsif language=="csv"
        table_html(code)        
      elsif language
        lexer = Rouge::Lexer.find_fancy(language, code) || Rouge::Lexers::PlainText
        formatter = rouge_formatter(lexer)
        result = formatter.format(lexer.lex(code))
      else
        "\n<pre><code>#{code}</code></pre>\n"
      end
    end

    def codespan(code)
      if code[0..1] == "\\(" && code[-2..-1] == "\\)"
        "<script type=\"math/tex\">#{code}</script>"
      else
        "<code>#{code}</code>"
      end
    end
  end

  def markdown(text)
    render_options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: {rel: 'nofollow', target: "_blank"},
      prettify: true,
    }
    markdown_options = {
      no_intra_emphasis: true,
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      lax_spacing: true,
      superscript: true,
      underline: true,
      highlight: true,
      quote: true,
      footnotes: true,
    }

    renderer = MyRender.new(render_options)
    markdown = Redcarpet::Markdown.new(renderer, markdown_options)

    markdown.render(text).html_safe
  end
end

# There is rouge.css.erb
