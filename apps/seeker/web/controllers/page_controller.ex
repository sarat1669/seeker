defmodule Seeker.PageController do
  use Seeker.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
