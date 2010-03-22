xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do

  xml.title   "#{@user.login}'s Tickets Atom Feed"
  xml.link    "rel" => "self", "href" => login_name_url(@user.login)
  xml.link    "rel" => "alternate", "href" => login_name_url(@user.login)
  xml.id      url_for(:only_path => false, :controller => 'users')
  xml.updated @tickets.first.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @tickets.any?
  xml.author  { xml.name "#{@user.login}" }

  @tickets.each do |ticket|
    xml.entry do
      xml.title   truncate(ticket.content, 80, "...")
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => 'tickets', :action => 'show', :id => ticket.id)
      xml.id      url_for(:only_path => false, :controller => 'tickets', :action => 'show', :id => ticket.id)
      xml.updated ticket.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name @user.login }
      xml.summary "Post summary"
      xml.content "type" => "html" do
        xml.text! nicely_format(ticket.content)
      end
    end
  end

end