defmodule VolunteerWeb.Services.Canny do
  def get_user_config(conn, should_anonymize) do
    get_user_config(
      VolunteerWeb.UserSession.get_user(conn),
      VolunteerWeb.SessionIdentifier.get_id(conn),
      should_anonymize
    )
  end

  def get_user_config(nil, session_id, _should_anonymize) do
    session_id_encoded =
      Base.url_encode64(session_id)

    %{
      id: session_id_encoded,
      name: "Anonymous",
      email: "#{session_id_encoded}@iicanada.net"
    }
  end

  def get_user_config(user, _session_id, true) do
    user_id_hash =
      :crypto.hash(:sha256, "#{user.id}") |> Base.url_encode64()

    %{
      id: user_id_hash,
      name: "Anonymous",
      email: "#{user_id_hash}@iicanada.net"
    }
  end

  def get_user_config(user, _session_id, false) do
    %{
      id: user.id,
      name: user.title,
      email: user.primary_email,
    }
  end

  def get_config("admin", user) do
    %{
      board_token: "cd9750db-a512-715a-4227-f1c4353cc9dd",
      base_path: "/admin/feedback",
      sso_token: encode_token(user)
    }
  end

  def get_config("public", user) do
    %{
      board_token: "63716c8c-d3cd-c19f-37d0-52e7428fcb60",
      base_path: "/feedback",
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
