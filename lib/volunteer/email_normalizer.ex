defmodule Volunteer.EmailNormalizer do
  @regex ~r/([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,63})/i

  def extract_domain(raw_email) do
    case Regex.run(@regex, raw_email, capture: :all_but_first) do
      [match] ->
        [_local_part, domain] = String.split(match, "@")
        {:ok, domain}

      _ ->
        {:error, :no_email_found}
    end
  end

  def validate_and_normalize_change(changeset, field, opts \\ %{})

  def validate_and_normalize_change(changeset, field, %{type: :list} = opts) do
    case Ecto.Changeset.fetch_change(changeset, field) do
      :error ->
        changeset

      {:ok, nil} ->
        changeset

      {:ok, raw_emails_list} when is_list(raw_emails_list) ->
        case validate_and_normalize_list(raw_emails_list, opts) do
          {:ok, normalized_emails_list} ->
            Ecto.Changeset.put_change(changeset, field, normalized_emails_list)

          {:error, errored_emails_list} ->
            add_errors_to_changeset(changeset, field, errored_emails_list)
        end
    end
  end

  def validate_and_normalize_change(changeset, field, %{type: :comma_separated} = opts) do
    case Ecto.Changeset.fetch_change(changeset, field) do
      :error ->
        changeset

      {:ok, nil} ->
        changeset

      {:ok, raw_emails} when is_binary(raw_emails) ->
        raw_emails_list = String.split(raw_emails, ",")

        case validate_and_normalize_list(raw_emails_list, opts) do
          {:ok, normalized_emails_list} ->
            Ecto.Changeset.put_change(changeset, field, Enum.join(normalized_emails_list, ","))

          {:error, errored_emails_list} ->
            add_errors_to_changeset(changeset, field, errored_emails_list)
        end
    end
  end

  def validate_and_normalize_change(changeset, field, _opts) do
    case Ecto.Changeset.fetch_change(changeset, field) do
      :error ->
        changeset

      {:ok, nil} ->
        changeset

      {:ok, raw_email} when is_binary(raw_email) ->
        case validate_and_normalize(raw_email) do
          {:ok, normalized_email} ->
            Ecto.Changeset.put_change(changeset, field, normalized_email)

          {:error, errored_email} ->
            add_errors_to_changeset(changeset, field, [errored_email])
        end
    end
  end

  defp add_errors_to_changeset(changeset, field, errored_emails_list) do
    Enum.reduce(errored_emails_list, changeset, fn email, changeset ->
      Ecto.Changeset.add_error(changeset, field, "\"#{email}\" is not a valid email")
    end)
  end

  def validate_and_normalize_list(emails_list, opts \\ %{})

  def validate_and_normalize_list([], _opts) do
    {:ok, []}
  end

  def validate_and_normalize_list([email | _] = emails_list, _opts) when is_binary(email) do
    Enum.reduce(emails_list, {[], []}, fn email, {normalized, errored} ->
      case validate_and_normalize(email) do
        {:ok, email} ->
          {[email | normalized], errored}

        {:error, email} ->
          {normalized, [email | errored]}
      end
    end)
    |> case do
      {normalized, []} ->
        {:ok, normalized}

      {_normalized, errored} ->
        {:error, errored}
    end
  end

  def validate_and_normalize(email) when is_binary(email) do
    case Regex.run(@regex, email, capture: :all_but_first) do
      [match] ->
        {:ok, normalize(match)}

      _ ->
        {:error, email}
    end
  end

  def validate_and_normalize(email) do
    {:error, email}
  end

  def normalize(email) do
    [mailbox, domain] =
      String.split(email, "@")

    [mailbox, String.downcase(domain)] |> Enum.join("@")
  end

  def normalize_lowercase(email) do
    email
    |> normalize()
    |> String.downcase()
  end
end
