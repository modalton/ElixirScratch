defmodule Scratch.TestHelpers do
  alias Scratch.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
          name: "Adolf Bungler",
          username: "user#{Base.encode16(:crypto.strong_rand_bytes(8))}",
          password: "secret"
                         }, attrs)

    %Scratch.User{}
    |> Scratch.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_video(user,  attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:videos, attrs)
    |> Repo.insert!()
  end
  
  
end
