defmodule VolunteerEmail.Mailer do
  use Bamboo.Mailer, otp_app: :volunteer
  import Bamboo.Email, only: [new_email: 0, from: 2, cc: 2]
  import Bamboo.Phoenix, only: [put_html_layout: 2]

  def deliver_now!(email) do
    deliver_now(email)
  end

  def deliver_later!(email) do
    deliver_later(email)
  end

  def new_default_email(region_id) do
    region_system_email = system_email(region_id)

    new_email()
    |> from(region_system_email)
    |> cc([region_system_email])
    |> put_html_layout({VolunteerEmail.LayoutView, "email.html"})
  end

  def system_email(region_id) do
    {:ok, email} = Volunteer.Infrastructure.get_region_config(region_id, :system_email)
    email
  end
end
