defmodule VolunteerHardcoded.Roles.ReduceTest do
  use ExUnit.Case
  alias VolunteerHardcoded.Roles

  describe "by_primary_email/1" do
    test "works" do
      input = [
        region: %{
          1 => %{
            "z" => "admin",
            "y" => "cc_team"
          },
          2 => %{
            "z" => "cc_team"
          }
        },
        group: %{
          1 => %{
            "y" => "admin"
          }
        }
      ]
      expected = %{
        "z" => %{
          region: %{
            1 => "admin",
            2 => "cc_team"
          },
        },
        "y" => %{
          region: %{
            1 => "cc_team"
          },
          group: %{
            1 => "admin"
          }
        }
      }
      assert expected == Roles.Reduce.by_primary_email(input)
    end
  end
end
