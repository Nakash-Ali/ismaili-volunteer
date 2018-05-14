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
    |> Enum.map(fn
      addr when is_binary(addr) -> {addr, true}
      {name, addr} -> {addr, true}
    end)
    |> Enum.into(%{})
    |> Map.merge(seen_emails)
  end
  
  def filter_emails(nil, seen_emails) do
    {nil, seen_emails}
  end
  
  def filter_emails(pairs_to_filter, seen_emails) do
    # This will use Erlang's default term sort, which will sort
    # tuples at a lower index than strings, which is what we want
    # here because a tuple will contain both the name and email,
    # which is preferred to just the email.
    sorted_pairs =
      Enum.sort(pairs_to_filter)
    filter_emails(sorted_pairs, seen_emails, [])
  end
  
  def filter_emails([], seen_emails, filtered_pairs) do
    {filtered_pairs, seen_emails}
  end
  
  def filter_emails(pairs_to_filter, seen_emails, filtered_pairs) do
    {pair_to_check, new_pairs_to_filyer} =
      List.pop_at(pairs_to_filter, 0)
    addr =
      case pair_to_check do
        addr when is_binary(addr) -> addr
        {name, addr} -> addr
      end
      |> String.downcase()
    new_filtered_pairs =
      case seen_emails[addr] do
        nil ->
          [pair_to_check | filtered_pairs]
        _ ->
          filtered_pairs
      end
    new_seen_emails =
      Map.put(seen_emails, addr, true)
    filter_emails(new_pairs_to_filyer, new_seen_emails, new_filtered_pairs)
  end
  
  def ensure_unique_addresses(email) do
    with seen_emails <- update_seen_emails([email.to], %{}),
      {filtered_cc, seen_emails} <- filter_emails(email.cc, seen_emails),
      {filtered_bcc, _seen_emails} <- filter_emails(email.bcc, seen_emails),
    do:
      email
      |> Map.put(:cc, filtered_cc)
      |> Map.put(:bcc, filtered_bcc)
  end
end
