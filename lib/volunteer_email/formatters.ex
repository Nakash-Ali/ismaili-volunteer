defimpl Bamboo.Formatter, for: Volunteer.Accounts.User do
  def format_email_address(user, _opts) do
    {user.title, user.primary_email}
  end
end
