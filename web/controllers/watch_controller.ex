defmodule Scratch.WatchController do
  use Scratch.Web, :controller
  alias Scratch.Video

  def show(conn, %{"id" => id}) do
    video = Repo.get!(Video, id)
    render conn, "show.html", video: video
  end

end
