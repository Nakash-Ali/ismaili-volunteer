# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Volunteer.Repo.insert!(%Volunteer.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alizain = 
  Volunteer.Accounts.create_user!(%{
      title: "Alizain's Test User",
      given_name: "Alizain",
      sur_name: "Test User",
      primary_email: "alizain.feerasta@iicanada.net"
    })
  
canada = 
  Volunteer.Infrastructure.create_region!(%{
      title: "Canada"
    })

Volunteer.Infrastructure.create_group!(%{
    title: "Council for Canada"
  }, canada)
