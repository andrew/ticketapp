xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do

  xml.title   "Replies to #{@user.login}'s Tickets Atom Feed"
  xml.link    "rel" => "self", "href" => replies_user_url(@user)
  xml.link    "rel" => "alternate", "href" => replies_user_url(@user)
  xml.id      replies_user_url(@user)
  xml.updated @user.recent_replies.first.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @user.recent_replies.any?
  xml.author  { xml.name "#{@user.login}" }

  @user.recent_replies.each do |ticket|
    xml.entry do
      xml.title   truncate(ticket.content, 80, "...")
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => 'tickets', :action => 'show', :id => ticket.id)
      xml.id      url_for(:only_path => false, :controller => 'tickets', :action => 'show', :id => ticket.id)
      xml.updated ticket.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name ticket.user.login }
      xml.summary "Post summary"
      xml.content "type" => "html" do
        xml.text! auto_link(simple_format(ticket.content))
      end
    end
  end

end