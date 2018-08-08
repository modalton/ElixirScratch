defmodule Scratch.HelloController do
  use Scratch.Web, :controller

  def hello(conn, %{"name" => name}) do
    render conn, "world.html", name: name
  end
end
