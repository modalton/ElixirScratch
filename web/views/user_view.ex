defmodule Scratch.UserView do
  use Scratch.Web, :view
  alias Scratch.User

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end