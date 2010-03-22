xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       "Replies to #{@user.login}'s Tickets RSS Feed"
    xml.link        replies_user_url(@user)
    xml.pubDate     CGI.rfc1123_date @user.recent_replies.first.updated_at if @user.recent_replies.any?
    xml.description "#{@user.login}'s Tickets RSS Feed"

    @user.recent_replies.each do |ticket|
      xml.item do
        xml.title       truncate(ticket.content, 80, "...")
        xml.link        ticket_path(ticket)
        xml.description auto_link(simple_format(ticket.content))
        xml.pubDate     CGI.rfc1123_date ticket.updated_at
        xml.guid        ticket_path(ticket)
        xml.author      "#{ticket.user.login}"
      end
    end

  end
end