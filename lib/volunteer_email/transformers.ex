defmodule VolunteerEmail.Transformers do
  def ensure_unique_addresses(email) do
    with seen_emails <- MapSet.new(),
         {filtered_to, seen_emails} <- filter_emails(Map.get(email, :to, nil), seen_emails),
         {filtered_cc, seen_emails} <- filter_emails(Map.get(email, :cc, nil), seen_emails),
         {filtered_bcc, _seen_emails} <- filter_emails(Map.get(email, :bcc, nil), seen_emails) do
      email
      |> Map.put(:to, filtered_to)
      |> Map.put(:cc, filtered_cc)
      |> Map.put(:bcc, filtered_bcc)
    end
  end

  defp update_pair_in_seen_emails(seen_emails, pair_to_check) do
    MapSet.put(seen_emails, normalized_addr_only(pair_to_check))
  end

  defp is_pair_in_seen_emails?(seen_emails, pair_to_check) do
    MapSet.member?(seen_emails, normalized_addr_only(pair_to_check))
  end

  defp normalized_addr_only({_name, addr}) do
    normalized_addr_only(addr)
  end

  defp normalized_addr_only(addr) when is_binary(addr) do
    Volunteer.EmailNormalizer.normalize_lowercase(addr)
  end

  defp filter_emails(nil, seen_emails) do
    {nil, seen_emails}
  end

  defp filter_emails(pair_to_filter, seen_emails) when not is_list(pair_to_filter) do
    filter_emails([pair_to_filter], seen_emails)
  end

  defp filter_emails(pairs_to_filter, seen_emails) do
    # This will use Erlang's default term sort, which will sort
    # tuples at a lower index than strings, which is what we want
    # here because a tuple will contain both the name and email,
    # which is preferred to just the email.
    pairs_to_filter
    |> Enum.sort()
    |> filter_emails(seen_emails, [])
  end

  defp filter_emails([], seen_emails, filtered_pairs) do
    {filtered_pairs, seen_emails}
  end

  defp filter_emails(pairs_to_filter, seen_emails, filtered_pairs) do
    [pair_to_check | new_pairs_to_filter] = pairs_to_filter

    new_filtered_pairs =
      if is_pair_in_seen_emails?(seen_emails, pair_to_check) do
        filtered_pairs
      else
        [pair_to_check | filtered_pairs]
      end

    filter_emails(
      new_pairs_to_filter,
      update_pair_in_seen_emails(seen_emails, pair_to_check),
      new_filtered_pairs
    )
  end
end
