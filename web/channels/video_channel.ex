defmodule Scratch.VideoChannel do
  use Scratch.Web, :channel
  alias Scratch.AnnotationView

  def join("videos:" <> video_id, _params, socket) do
    video_id = String.to_integer(video_id)
    video = Repo.get!(Scratch.Video, video_id)

    annotations = Repo.all(
      from a in assoc(video, :annotations),
      order_by: [asc: a.at, asc: a.id],
      limit: 200,
      preload: [:user]
    )
    resp = %{annotations: Phoenix.View.render_many(annotations, AnnotationView, "annotation.json")}
    {:ok, resp, assign(socket, :video_id, video_id)}
  end

  def handle_in(event, params, socket) do
    user = Repo.get(Scratch.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("new_annotation", params, user, socket) do
    changeset =
      user
      |> build_assoc(:annotations, video_id: socket.assigns.video_id)
      |> Scratch.Annotation.changeset(params)

    case Repo.insert(changeset) do
      {:ok, annotation} ->
        broadcast! socket, "new_annotation", %{
          id: annotation.id,
          user: Scratch.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
                   }
        {:reply, :ok, socket}
      {:error, changeset} ->
         {:reply, {:error, %{errors: changeset}}, socket}
    end 
  end
  
  # # Example of incrementing emission
  # def handle_info(:ping, socket) do
  #   count = socket.assigns[:count] || 1
  #   push socket, "ping", %{count: count}
  #   {:noreply, assign(socket, :count, count+1)}
  # end
  
end