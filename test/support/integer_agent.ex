defmodule Volunteer.TestSupport.IntegerAgent do
  def get() do
    System.unique_integer([:positive, :monotonic]) + 1_000_000
  end
end
