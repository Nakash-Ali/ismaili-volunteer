defmodule VolunteerWeb.Services.Canny do
  def config("admin", user) do
    %{
      board_token: "cd9750db-a512-715a-4227-f1c4353cc9dd",
      base_path: "/admin/feedback",
      sso_token: generate_sso_token(user)
    }
  end

  def generate_sso_token(%{
        id: id,
        title: name,
        primary_email: email
      }) do
    jwk = %{
      "kty" => "oct",
      "k" => Application.fetch_env!(:volunteer, :canny_private_key) |> Base.url_encode64()
    }

    jws = %{
      "alg" => "HS256"
    }

    jwt = %{
      "id" => id,
      "name" => name,
      "email" => email
    }

    {_meta, token} = JOSE.JWT.sign(jwk, jws, jwt) |> JOSE.JWS.compact()
    token
  end
end
