defmodule Scratch.AnnotationView do
  use Scratch.Web, :view

  def render("annotation.json", %{annotation: ann}) do
    %{
      id: ann.id,
      body: ann.body,
      at: ann.at,
      user: render_one(ann.user, Scratch.UserView, "user.json")
    }
  end

end
