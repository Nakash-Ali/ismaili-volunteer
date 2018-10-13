defmodule VolunteerEmail.Mailer do
  use Bamboo.Mailer, otp_app: :volunteer
  import Bamboo.Email, only: [new_email: 0, from: 2]
  import Bamboo.Phoenix, only: [put_html_layout: 2]

  def new_default_email() do
    new_email()
    |> from(system_email())
    |> put_html_layout({VolunteerEmail.LayoutView, "email.html"})
  end

  def system_email() do
    :volunteer
    |> Application.fetch_env!(VolunteerEmail)
    |> Keyword.fetch!(:system_email)
  end
end
