defimpl Bamboo.Formatter, for: Volunteer.Accounts.User do
  alias VolunteerWeb.Presenters.Title

  def format_email_address(user, _opts) do
    {Title.text(user), user.primary_email}
  end
end

defimpl Bamboo.Formatter, for: VolunteerHardcoded.User do
  def format_email_address(%{primary_email: primary_email}, _opts) do
    {nil, primary_email}
  end
end
