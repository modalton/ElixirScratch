defmodule Scratch.PageControllerTest do
  use Scratch.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Scratch!"
  end
end
