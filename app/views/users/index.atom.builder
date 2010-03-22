xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do

  xml.title   "New Users on Tickets Atom Feed"
  xml.link    "rel" => "self", "href" => users_path
  xml.link    "rel" => "alternate", "href" => users_path
  xml.id      users_path
  xml.updated User.recent.first.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ" if User.recent.any?
  xml.author  { xml.name "Ticketapp" }

  User.recent.each do |user|
    xml.entry do
      xml.title   user.login
      xml.link    "rel" => "alternate", "href" => login_name_url(user.login)
      xml.id      login_name_url(user.login)
      xml.updated user.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name "Ticketapp" }
      xml.summary "Post summary"
      xml.content "type" => "html" do
        xml.text! user.login
      end
    end
  end

end