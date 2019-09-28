defmodule VolunteerWeb.Services.Filestack do
  @default_expires_in [minutes: 10]

  @base_props %{
    max_size: 10 * 1024 * 1024,
    call: ["pick"]
  }

  def generate_security(props \\ %{}, expires_in \\ @default_expires_in) do
    policy = generate_policy(props, expires_in)
    signature = generate_signature(policy)

    %{policy: policy, signature: signature}
  end

  defp generate_signature(policy) do
    :crypto.hmac(
      :sha256,
      Application.fetch_env!(:volunteer, :filestack) |> Keyword.fetch!(:app_secret),
      policy
    )
    |> Base.encode16(case: :lower)
  end

  defp generate_policy(props, expires_in) do
    generate_policy_props(props, expires_in)
    |> Jason.encode!
    |> Base.url_encode64
  end

  defp generate_policy_props(props, expires_in) do
    @base_props
    |> Map.merge(props)
    |> Map.put(:expiry, calculate_expiry_unix(expires_in))
  end

  defp calculate_expiry_unix(expires_in) do
    Timex.now
    |> Timex.shift(expires_in)
    |> DateTime.to_unix
  end
end
