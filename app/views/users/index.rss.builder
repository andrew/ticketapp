xml.instruct!

xml.rss "version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/" do
  xml.channel do

    xml.title       "New Users on Tickets RSS Feed"
    xml.link        users_url
    xml.pubDate     CGI.rfc1123_date User.recent.first.updated_at if User.recent.any?
    xml.description "Users on Tickets"

    User.recent.each do |user|
      xml.item do
        xml.title       user.login
        xml.link        login_name_url(user.login)
        xml.description user.login
        xml.pubDate     CGI.rfc1123_date user.updated_at
        xml.guid        login_name_url(user.login)
        xml.author      "Ticketapp"
      end
    end

  end
end