defmodule Volunteer.Accounts.Auth do

  def upsert_together_and_return(%Ueberauth.Auth{} = auth) do
    Volunteer.Accounts.upsert_together_and_return(%{
      provider_id:    auth.uid,
      provider:       Atom.to_string(auth.provider),
      title:          auth.info.name,
      given_name:     auth.info.first_name,
      sur_name:       auth.info.last_name,
      primary_email:  auth.info.email,
      })
  end

end
