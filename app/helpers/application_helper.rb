module ApplicationHelper
  
  def nicely_format(content)
    simple_format(white_list(auto_link(auto_link_images(content)){ |text| truncate(text, 50) }))
  end
    
  def gently_escape(title)
    strip_tags(title).strip.gsub(/['"\n\r]/, "") unless title.blank?
  end
  
  def nice_time(time)
    h time.strftime("%M")
  end
  
  AUTO_LINK_IMAGE_RE = %r{
                          (                          # leading text
                            <\w+.*?>|                # leading HTML tag, or
                            [^=!:'"/]|               # leading punctuation, or 
                            ^                        # beginning of line
                          )
                          (
                            (?:https?://)|           # protocol spec, or
                            (?:www\.)                # www.*
                          ) 
                          (
                            [-\w]+                   # subdomain or domain
                            (?:\.[-\w]+)*            # remaining subdomains or domain
                            (?::\d+)?                # port
                            (?:/(?:(?:[~\w\+@%-]|(?:[,.;:][^\s$]))+)?)*.(jpg|gif|png) # path
                            (?:\?[\w\+@%&=.;-]+)?     # query string
                            (?:\#[\w\-]*)?           # trailing anchor
                          )
                          ([[:punct:]]|\s|<|$)       # trailing text
                         }x unless const_defined?(:AUTO_LINK_IMAGE_RE)
  
  def auto_link_images(text, href_options = {})
    extra_options = tag_options(href_options.stringify_keys) || ""
    text.gsub(AUTO_LINK_IMAGE_RE) do
      all, a, b, c, d = $&, $1, $2, $3, $4
      if a =~ /<a\s/i # don't replace URL's that are already linked
        all
      else
        text = b + c
        text = yield(text) if block_given?
        "<a href='#{all.strip}'><img src='#{all.strip}'/></a>"
      end
    end
  end
  
end
