defmodule Volunteer.Listings.Introspect do
  def cc_emails(%{cc_emails: ""}) do
    []
  end

  def cc_emails(%{cc_emails: cc_emails}) do
    String.split(cc_emails, ",")
  end
end
