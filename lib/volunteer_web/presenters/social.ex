defprotocol VolunteerWeb.Presenters.Social do
  def url(data, conn)
  def type(data)
  def title(data)
  def description(data)
  def image_src(data)
  def image_src_size(data)
  def image_abs_url(data, conn)
  def popup_onclick(data)
end

defimpl VolunteerWeb.Presenters.Social, for: Volunteer.Listings.Listing do
  alias VolunteerWeb.Router.Helpers, as: RouterHelpers

  def url(listing, conn) do
    RouterHelpers.listing_url(conn, :show, listing)
  end

  def type(_listing) do
    "listing"
  end

  def title(listing) do
    "Apply for #{VolunteerWeb.Presenters.Title.plain(listing)}!"
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

  def image_abs_url(listing, conn) do
    RouterHelpers.listing_social_image_url(conn, :png, listing)
  end

  def popup_onclick(_listing) do
    "window.open(this.href, '_blank', 'left=100,top=100,width=900,height=600,menubar=no,toolbar=no,resizable=yes,scrollbars=yes'); return false;"
  end
end
