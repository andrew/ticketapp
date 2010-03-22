xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       "Recent Tickets RSS Feed"
    xml.link        tickets_url
    xml.pubDate     CGI.rfc1123_date @tickets.first.updated_at if @tickets.any?
    xml.description "Recent Tickets RSS Feed"

    @tickets.each do |ticket|
      xml.item do
        xml.title       truncate(ticket.content, 80, "...")
        xml.link        ticket_path(ticket)
        xml.description render :partial => 'tickets/feed_ticket.html.erb', :locals => {:ticket => ticket}
        xml.pubDate     CGI.rfc1123_date ticket.updated_at
        xml.guid        ticket_path(ticket)
        xml.author      "#{ticket.user.login}"
      end
    end

  end
end