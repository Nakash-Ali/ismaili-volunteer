defmodule Volunteer.TestFactory do
  defmodule Params do
    def user(overrides) do
      %{
        id: System.unique_integer([:positive]),
        title: Faker.Name.name(),
        given_name: Faker.Name.first_name(),
        sur_name: Faker.Name.last_name(),
        primary_email: Faker.Internet.free_email(),
        primary_phone: Faker.Phone.EnUs.phone(),
      }
      |> Map.merge(overrides)
    end

    def region(overrides) do
      %{
        id: System.unique_integer([:positive]),
        title: Faker.Address.city(),
      }
      |> Map.merge(overrides)
    end

    def group(overrides) do
      %{
        id: System.unique_integer([:positive]),
        title: Faker.Company.name(),
        region_id: System.unique_integer([:positive])
      }
      |> Map.merge(overrides)
    end

    def listing(overrides) do
      %{
        id: System.unique_integer([:positive]),
        created_by: System.unique_integer([:positive]),
        position_title: Faker.Superhero.name(),
        program_title: Faker.Commerce.department(),
        summary_line: Faker.Lorem.words(4..12) |> Enum.join(" "),
        region_id: System.unique_integer([:positive]),
        group_id: System.unique_integer([:positive]),
        organized_by_id: System.unique_integer([:positive]),
        start_date: Faker.Date.backward(100),
        end_date: Faker.Date.forward(200),
        hours_per_week: Faker.random_between(0, 10),
        program_description: Faker.Lorem.sentences(2..5) |> Enum.join(" "),
        responsibilities: Faker.Lorem.sentences(2..5) |> Enum.join(" "),
        qualifications: Faker.Lorem.sentences(2..5) |> Enum.join(" "),
      }
      |> Map.merge(overrides)
    end
  end

  def user!(opts \\ %{}, repo \\ Volunteer.Repo) do
    overrides = Map.get(opts, :overrides, %{})

    Volunteer.Accounts.User
    |> struct(Params.user(overrides))
    |> repo.insert!()
  end

  def region!(opts \\ %{}, repo \\ Volunteer.Repo) do
    overrides = Map.get(opts, :overrides, %{})

    Volunteer.Infrastructure.Region
    |> struct(Params.region(overrides))
    |> repo.insert!()
  end

  def group!(opts \\ %{}, repo \\ Volunteer.Repo) do
    overrides =
      opts
      |> Map.get(:overrides, %{})
      |> Map.put_new_lazy(:region_id, fn -> region!().id end)

    Volunteer.Infrastructure.Group
    |> struct(Params.group(overrides))
    |> repo.insert!()
  end
end
