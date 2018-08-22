defmodule Scratch.Video do
  use Scratch.Web, :model
  @primary_key {:id, Scratch.Permalink, autogenerate: true}

  schema "videos" do
    field :url, :string
    field :title, :string
    field :description, :string
    field :slug, :string
    belongs_to :user, Scratch.User, foreign_key: :user_id
    belongs_to :category, Scratch.Category
    has_many :annotations, Scratch.Annotation
    
    timestamps()
  end

  @required_fields ~w(url title description)
  @optional_fields ~w(category_id)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  
  defp slugify(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/u,"-")
  end
  
  defp slugify_title(changeset) do
    if title = get_change(changeset, :title) do
      put_change(changeset, :slug, slugify(title))
    else
      changeset
    end
  end
  
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> slugify_title()
    |> assoc_constraint(:category)
  end
end

defimpl Phoenix.Param, for: Scratch.Video do
  def to_param(%{slug: slug, id: id}) do
    "#{id}-#{slug}"
  end
end
