defmodule Volunteer.TestSupport.Emails do
  import ExUnit.Assertions, only: [assert_receive: 3, flunk: 1]

  def assert_delivered(email) do
    normalized_email =
      email
      |> Bamboo.Test.normalize_for_testing()
      |> sort_email()

    assert_receive({:delivered_email, ^normalized_email}, 100, Bamboo.Test.flunk_with_email_list(normalized_email))
  end

  def sort_email(email) do
    email
    |> Map.update!(:to, &sort_address_list/1)
    |> Map.update!(:cc, &sort_address_list/1)
    |> Map.update!(:bcc, &sort_address_list/1)
  end

  def sort_address_list(address_list) when is_list(address_list) do
    address_list
    |> Enum.sort()
    |> Enum.reverse()
  end

  def sort_address_list(address) do
    address
  end
end
