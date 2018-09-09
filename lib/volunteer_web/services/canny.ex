defmodule VolunteerWeb.Services.Canny do
  def get_config("admin", user) do
    %{
      board_token: "cd9750db-a512-715a-4227-f1c4353cc9dd",
      base_path: "/admin/feedback",
      sso_token: encode_token(user)
    }
  end

  def encode_token(token_claims) do
    jwk = %{
      "kty" => "oct",
      "k" => Application.fetch_env!(:volunteer, :canny_private_key) |> Base.url_encode64()
    }

    jws = %{
      "alg" => "HS256"
    }

    {_meta, token} =
      JOSE.JWT.sign(jwk, jws, token_claims)
      |> JOSE.JWS.compact()

    token
  end
end
