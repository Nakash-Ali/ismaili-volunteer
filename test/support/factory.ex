defmodule Volunteer.TestSupport.Factory do
  def cast_all(params, module) do
    Ecto.Changeset.cast(
      struct(module, %{}),
      params,
      module.__schema__(:fields),
      empty_values: []
    )
  end

  defmodule Params do
    def user(overrides) do
      %{
        id: Volunteer.TestSupport.IntegerAgent.get(),
        title: Faker.Name.name(),
        given_name: Faker.Name.first_name(),
        sur_name: Faker.Name.last_name(),
        primary_email: Faker.Internet.free_email(),
        primary_phone: Faker.Phone.EnUs.phone(),
        preferred_contact: [],
        primary_jamatkhanas: [],
        ismaili_status: "",
        education_level: "",
      }
      |> Map.merge(overrides)
    end

    def region(overrides) do
      title = Faker.Address.city()

      %{
        id: Volunteer.TestSupport.IntegerAgent.get(),
        title: title,
        slug: Volunteer.Infrastructure.Region.slugify(title)
      }
      |> Map.merge(overrides)
    end

    def group(overrides) do
      %{
        id: Volunteer.TestSupport.IntegerAgent.get(),
        title: Faker.Company.name(),
        region_id: Volunteer.TestSupport.IntegerAgent.get()
      }
      |> Map.merge(overrides)
    end

    def listing(overrides) do
      %{
        id: Volunteer.TestSupport.IntegerAgent.get(),
        created_by_id: Volunteer.TestSupport.IntegerAgent.get(),
        position_title: Faker.Superhero.name(),
        program_title: Faker.Commerce.department(),
        summary_line: Faker.Lorem.words(4..12) |> Enum.join(" "),
        region_id: Volunteer.TestSupport.IntegerAgent.get(),
        group_id: Volunteer.TestSupport.IntegerAgent.get(),
        organized_by_id: Volunteer.TestSupport.IntegerAgent.get(),
        start_date: Faker.Date.backward(100),
        end_date: Faker.Date.forward(200),
        time_commitment_amount: Faker.random_between(1, 10),
        time_commitment_type: Volunteer.Listings.Change.time_commitment_type_choices() |> Enum.random(),
        program_description: Faker.Lorem.sentences(2..5) |> Enum.join(" "),
        responsibilities: Faker.Lorem.sentences(2..5) |> Enum.join(" "),
        qualifications: Faker.Lorem.sentences(2..5) |> Enum.join(" "),
        qualifications_required: [],
        # TODO: this should nnot be required for default listings
        # public_expiry_date: Faker.DateTime.forward(6),
      }
      |> Map.merge(overrides)
    end

    def applicant(overrides) do
      %{
        id: Volunteer.TestSupport.IntegerAgent.get(),
        listing_id: Volunteer.TestSupport.IntegerAgent.get(),
        user_id: Volunteer.TestSupport.IntegerAgent.get(),
        confirm_availability: true,
        additional_info: Faker.Lorem.sentences(2..5) |> Enum.join(" "),
        hear_about: Faker.Lorem.sentences(1..2) |> Enum.join(" ")
      }
      |> Map.merge(overrides)
    end
  end

  def user!(opts \\ %{}, repo \\ Volunteer.Repo) do
    overrides =
      opts
      |> Map.get(:overrides, %{})
      |> Map.put_new_lazy(:inserted_at, fn -> Faker.DateTime.backward(24) end)

    Params.user(overrides)
    |> cast_all(Volunteer.Accounts.User)
    |> repo.insert!(on_conflict: :nothing, conflict_target: [:id])
  end

  def region!(opts \\ %{}, repo \\ Volunteer.Repo) do
    overrides =
      opts
      |> Map.get(:overrides, %{})
      |> Map.put_new_lazy(:inserted_at, fn -> Faker.DateTime.backward(24) end)

    Params.region(overrides)
    |> cast_all(Volunteer.Infrastructure.Region)
    |> repo.insert!(on_conflict: :nothing, conflict_target: [:id])
  end

  def group!(opts \\ %{}, repo \\ Volunteer.Repo) do
    overrides =
      opts
      |> Map.get(:overrides, %{})
      |> Map.put_new_lazy(:inserted_at, fn -> Faker.DateTime.backward(24) end)
      |> Map.put_new_lazy(:region_id, fn -> region!().id end)

    Params.group(overrides)
    |> cast_all(Volunteer.Infrastructure.Group)
    |> repo.insert!(on_conflict: :nothing, conflict_target: [:id])
  end

  def listing!(opts \\ %{}, repo \\ Volunteer.Repo) do
    overrides = Map.get(opts, :overrides, %{})

    inserted_at = Map.get_lazy(overrides, :inserted_at, fn -> Faker.DateTime.backward(24) end)

    region_id = Map.get_lazy(overrides, :region_id, fn -> region!().id end)

    group_id =
      Map.get_lazy(overrides, :group_id, fn ->
        group!(%{
          overrides: %{region_id: region_id}
        }).id
      end)

    created_by_id = Map.get_lazy(overrides, :created_by_id, fn -> user!().id end)

    organized_by_id = Map.get_lazy(overrides, :organized_by_id, fn -> user!().id end)

    public_expiry_date =
      if Map.get(opts, :expired?, false) do
        Faker.DateTime.between(inserted_at, Faker.DateTime.backward(1))
      else
        Faker.DateTime.forward(8)
      end

    {public_approved, public_approved_on, public_approved_by_id} =
      if Map.get(opts, :approved?, false) do
        public_approved = Faker.DateTime.between(inserted_at, Faker.DateTime.backward(1))
        public_approved_by_id = Map.get_lazy(overrides, :public_approved_by_id, fn -> user!().id end)
        {true, public_approved, public_approved_by_id}
      else
        {false, nil, nil}
      end

    %{
      inserted_at: inserted_at,
      region_id: region_id,
      group_id: group_id,
      created_by_id: created_by_id,
      organized_by_id: organized_by_id,
      public_expiry_date: public_expiry_date,
      public_approved: public_approved,
      public_approved_on: public_approved_on,
      public_approved_by_id: public_approved_by_id
    }
    |> Map.merge(overrides)
    |> Params.listing()
    |> cast_all(Volunteer.Listings.Listing)
    |> repo.insert!(on_conflict: :nothing, conflict_target: [:id])
  end
end
