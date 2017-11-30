defmodule VolunteerEmail.Mailer do
  use Bamboo.Mailer, otp_app: :volunteer

  import Bamboo.Email, only: [new_email: 0, from: 2]
  import Bamboo.Phoenix, only: [put_html_layout: 2]

  @from_email {"ServeWithUs", "servewithus@iicanada.org"}

  def default_email() do
    new_email()
      |> from(@from_email)
      |> put_html_layout({VolunteerEmail.LayoutView, "email.html"})
  end
end
