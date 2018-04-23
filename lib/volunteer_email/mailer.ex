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
  
  def update_seen_emails(filtered_pairs, seen_emails) do
    filtered_pairs
    |> Enum.map(fn pair -> {pair, true} end)
    |> Enum.into(%{})
    |> Map.merge(seen_emails)
  end
  
  def filter_emails(nil, seen_emails) do
    {nil, seen_emails}
  end
  
  def filter_emails(pairs_to_filter, seen_emails) do
    filtered_pairs =
      pairs_to_filter
      |> Enum.uniq
      |> Enum.filter(fn pair -> seen_emails[pair] == nil end)
    {filtered_pairs, update_seen_emails(filtered_pairs, seen_emails)}
  end
  
  def ensure_unique_addresses(email) do
    with seen_emails <- update_seen_emails([email.to], %{}),
      {filtered_cc, seen_emails} <- filter_emails(email.cc, seen_emails),
      {filtered_bcc, seen_emails} <- filter_emails(email.bcc, seen_emails),
    do:
      email
      |> Map.put(:cc, filtered_cc)
      |> Map.put(:bcc, filtered_bcc)
  end
end
