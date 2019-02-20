defimpl Bamboo.Formatter, for: Volunteer.Accounts.User do
  alias VolunteerWeb.Presenters.Title

  def format_email_address(user, _opts) do
    {Title.text(user), user.primary_email}
  end
end
