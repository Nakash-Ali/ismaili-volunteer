defprotocol VolunteerWeb.Presenters.Social do
  def url(data, conn)
  def type(data)
  def title(data)
  def description(data)
  def image_src(data)
  def image_src_size(data)
  def image_abs_url(data, conn)
end

defimpl VolunteerWeb.Presenters.Social, for: Volunteer.Apply.Listing do
  import VolunteerWeb.Router.Helpers
  
  def url(listing, conn) do
    listing_url(conn, :show, listing)
  end
  
  def type(_listing) do
    "listing"
  end
  
  def title(listing) do
    "Apply now for #{VolunteerWeb.Presenters.Title.text(listing)}!"
  end
  
  def description(listing) do
    listing.summary_line
  end
  
  def image_src(_listing) do
    nil
  end
  
  def image_src_size(_listing) do
    {nil, nil}
  end
  
  def image_abs_url(_listing, _conn) do
    # static_url(conn, "/")
    nil
  end
end
