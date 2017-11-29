require IEx

defmodule Volunteer.Legacy do
  import Bamboo.Email
  use Bamboo.Phoenix, view: VolunteerEmail.LegacyView

  alias Ecto.Changeset
  alias VolunteerEmail.Mailer

  @all_jamatkhanas [
    "Headquarters",
    "Barrie",
    "Belleville",
    "Bobcaygeon",
    "Brampton",
    "Brantford",
    "Don Mills",
    "Downtown",
    "East York",
    "Etobicoke",
    "Guelph",
    "Halton",
    "Hamilton",
    "Kitchener",
    "London",
    "Mississauga",
    "Niagara Falls",
    "Oshawa",
    "Pickering",
    "Richmond Hill",
    "Scarborough",
    "St. Thomas",
    "Sudbury",
    "Unionville",
    "Willowdale",
    "Windsor"
  ]

  @types %{
    name: :string,
    email: :string,
    phone: :string,
    jamatkhana: :string,
    other_info: :string,
    hear_about: :string,
    preferred_contact: :string,
    affirm: :boolean,
    cc: {:array, :string},
    subject: :string,
    next: :string
  }

  @required [
    :name,
    :email,
    :phone,
    :jamatkhana,
    :preferred_contact,
    :affirm,
    :cc,
    :subject,
    :next,
  ]

  defstruct @required

  def apply(params) when is_map(params) do
    changeset = {%{}, @types}
      |> Changeset.cast(params, Map.keys(@types))
      |> Changeset.validate_required(@required)
      |> Changeset.validate_format(:email, ~r/\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b/i)
      |> Changeset.validate_inclusion(:jamatkhana, @all_jamatkhanas)
      |> Changeset.validate_inclusion(:preferred_contact, ["email", "phone"])
      |> Changeset.validate_acceptance(:affirm)

    with %{valid?: true} <- changeset,
         legacy <- struct(Volunteer.Legacy, changeset.changes),
         {:ok, _} <- send_emails(legacy)
    do
      {:ok, legacy}
    else
      %{valid?: false} -> {:error, changeset}
      {:error, error} -> {:error, error}
    end
  end

  defp send_emails(%Volunteer.Legacy{} = data) do
    [
      &welcome_email/1
    ]
      |> Enum.map(fn email_func -> email_func.(data) end)
      |> Enum.map(fn email -> Mailer.deliver_now(email) end)
  end

  defp default_email() do
    new_email()
      |> from("me@example.com")
  end

  def welcome_email(%Volunteer.Legacy{} = data) do
    default_email()
      |> to({data.name, data.email})
      |> cc(data.cc)
      |> subject(data.subject)
      |> html_body("<strong>Welcome</strong>")
      |> text_body("welcome")
  end
end
