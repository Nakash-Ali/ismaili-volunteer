%{
  given_name: "A",
  sur_name: "Z",
  primary_email: "alizain.feerasta@iicanada.net"
}
|> Volunteer.Accounts.User.changeset_authenticated()
|> Volunteer.Repo.insert!
