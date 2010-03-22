xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       "#{@user.login}'s Tickets RSS Feed"
    xml.link        login_name_url(@user.login)
    xml.pubDate     CGI.rfc1123_date @tickets.first.updated_at if @tickets.any?
    xml.description "#{@user.login}'s Tickets RSS Feed"

    @tickets.each do |ticket|
      xml.item do
        xml.title       truncate(ticket.content, 80, "...")
        xml.link        ticket_path(ticket)
        xml.description nicely_format(ticket.content)
        xml.pubDate     CGI.rfc1123_date ticket.updated_at
        xml.guid        ticket_path(ticket)
        xml.author      "#{@user.login}"
      end
    end

  end
end