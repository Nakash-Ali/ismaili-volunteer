defmodule Volunteer.Accounts.Auth do
  @allowed_auth_email_domains Application.fetch_env!(:volunteer, :allowed_auth_email_domains)

  def allowed_auth_email_domain?(email) do
    case Volunteer.EmailNormalizer.extract_domain(email) do
      {:ok, domain} when domain in @allowed_auth_email_domains ->
        {:ok, domain}

      _ ->
        {:error, :auth_email_domain_not_allowed}
    end
  end

  def upsert_together_and_return(%Ueberauth.Auth{} = auth) do
    case allowed_auth_email_domain?(auth.info.email) do
      {:ok, _} ->
        Volunteer.Accounts.upsert_together_and_return(%{
          provider_id: auth.uid,
          provider: Atom.to_string(auth.provider),
          title: auth.info.name,
          given_name: auth.info.first_name,
          sur_name: auth.info.last_name,
          primary_email: auth.info.email
        })

      {:error, _} = error ->
        error
    end
  end
end
