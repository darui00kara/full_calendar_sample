defmodule FullCarendarSample.PageController do
  use FullCarendarSample.Web, :controller

  alias FullCarendarSample.Event

  def index(conn, _params) do
    events = Repo.all(Event) |> Event.to_events_data_format |> Poison.encode!
    render conn, "index.html", events: events
  end
end