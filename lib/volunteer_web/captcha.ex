defmodule VolunteerWeb.Captcha do
  def verify(%Plug.Conn{params: params} = _conn) do
    case Recaptcha.verify(params["g-recaptcha-response"]) do
      {:ok, _} = result ->
        result

      {:error, reasons} = result ->
        IO.inspect(reasons)

        result
    end
  end
end
