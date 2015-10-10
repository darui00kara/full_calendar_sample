defmodule FullCarendarSample.PageController do
  use FullCarendarSample.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
