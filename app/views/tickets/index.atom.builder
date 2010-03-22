xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do

  xml.title   "Recent Tickets Atom Feed"
  xml.link    "rel" => "self", "href" => tickets_url
  xml.link    "rel" => "alternate", "href" => tickets_url
  xml.id      tickets_url
  xml.updated @tickets.first.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @tickets.any?
  xml.author  { xml.name "Ticketapp" }

  @tickets.each do |ticket|
    xml.entry do
      xml.title   truncate(ticket.content, 80, "...")
      xml.link    "rel" => "alternate", "href" => url_for(:only_path => false, :controller => 'tickets', :action => 'show', :id => ticket.id)
      xml.id      url_for(:only_path => false, :controller => 'tickets', :action => 'show', :id => ticket.id)
      xml.updated ticket.updated_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name ticket.user.login }
      xml.summary "type" => "html" do
        xml.text! render :partial => 'tickets/feed_ticket.html.erb', :locals => {:ticket => ticket, :type => 'multi'}
      end
      xml.content "type" => "html" do
        xml.text! render :partial => 'tickets/feed_ticket.html.erb', :locals => {:ticket => ticket, :type => 'multi'}
      end
    end
  end

end