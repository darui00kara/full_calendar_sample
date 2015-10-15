defmodule FullCarendarSample.PageController do
  use FullCarendarSample.Web, :controller

  def index(conn, _params) do
    events = Poison.encode!([%{id: 1, title: "hoge", start: "2015-10-15", end: "", url: ""},
                             %{id: 2, title: "huge", start: "2015-10-16", end: "2015-10-18", url: ""},
                             %{id: 3, title: "foo", start: "2015-10-21T12:00:00", end: "", url: ""},
                             %{id: 4, title: "bar", start: "2015-10-22T12:00:00", end: "2015-10-25T15:00:00", url: ""}])
    render conn, "index.html", events: events
  end
end
