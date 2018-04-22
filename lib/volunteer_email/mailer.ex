defmodule VolunteerEmail.Mailer do
  use Bamboo.Mailer, otp_app: :volunteer

  import Bamboo.Email, only: [new_email: 0, from: 2]
  import Bamboo.Phoenix, only: [put_html_layout: 2]

  @env Application.fetch_env!(:volunteer, VolunteerEmail)
  @from_email Keyword.fetch!(@env, :from_email)

  def new_default_email() do
    new_email()
    |> from(@from_email)
    |> put_html_layout({VolunteerEmail.LayoutView, "email.html"})
  end

  def from_email() do
    @from_email
  end
end
