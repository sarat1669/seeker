defmodule SeekerWeb.PageController do
  @moduledoc false

  use SeekerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
