# Title: A nice quote tag to quote something
# Author: David Westerink <https://myautisticself.nl>
# Description: Show quotes with ease from a post
# Examples:
# {% quote cite="Cite Name" cite_link="https://link.to" %} This is the quote! {% endquote %}
# {% quote cite="Cite Name" %} This is the quote! {% endquote %}
# {% quote %} This is the quote! {% endquote %}

module Jekyll
  class NiceQuote < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @options = parse_options(markup)
    end

    def render(context)
      quote = super.strip.gsub(/\n\n/, '</p><p>').gsub(/\n/, '<br/>')

      quote = content_tag :p, quote
      block = content_tag :blockquote, "#{quote} #{add_cite}"
      div = content_tag :div, block, class: 'quote'
      div
    end

    private

    def add_cite
      return if @options[:cite].nil?

      cite = content_tag :cite, @options[:cite]
      return cite if @options[:cite_link].nil?

      link = content_tag :a, @options[:cite], href: @options[:cite_link]
      cite = content_tag :cite, link

      cite
    end

    OPTIONS_REGEX = /(?:\w+="[^"]*")+/.freeze

    def parse_options(input)
      options = {}
      return options if input.empty?

      input.scan(OPTIONS_REGEX) do |opt|
        key, value = opt.split('=')
        options[key.to_sym] = value.gsub('"', '')
      end

      options
    end

    def content_tag(name, content_or_attributes, attributes = {})
      if content_or_attributes.is_a?(Hash)
        content = nil
        attributes = content_or_attributes
      else
        content = content_or_attributes
      end

      attributes = attributes.map { |k, v| %(#{k}="#{v}") }

      if content.nil?
        "<#{[name, attributes].flatten.compact.join(' ')}/>"
      else
        "<#{[name, attributes].flatten.compact.join(' ')}>#{content}</#{name}>"
      end
    end
  end
end

Liquid::Template.register_tag('quote', Jekyll::NiceQuote)
