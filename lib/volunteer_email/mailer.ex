defmodule VolunteerEmail.Mailer do
  import Bamboo.Email, only: [new_email: 0, from: 2]
  import Bamboo.Phoenix, only: [put_html_layout: 2]

  def deliver_now(email) do
    config = build_config()
    Bamboo.Mailer.deliver_now(config.adapter, finalize_email(email), config)
  end

  def deliver_later(email) do
    config = build_config()
    Bamboo.Mailer.deliver_later(config.adapter, finalize_email(email), config)
  end

  def build_config() do
    Bamboo.Mailer.build_config(__MODULE__, :volunteer)
  end

  def finalize_email(email) do
    email
    |> VolunteerEmail.Transformers.ensure_unique_addresses()
  end

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
