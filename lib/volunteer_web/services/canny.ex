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
      primary_email: email,
    }) do
    {:ok, token, _claims} =
      Joken.generate_and_sign(
        %{},
        %{
          id: id,
          name: name,
          email: email,
        },
        Joken.Signer.create("HS256", Application.fetch_env!(:volunteer, :canny_private_key))
      )
    token
  end
end
