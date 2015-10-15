# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FullCarendarSample.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias FullCarendarSample.Event
alias FullCarendarSample.Repo

events = [%{title: "hoge", start: "2015-10-15", end: "", url: ""},
          %{title: "huge", start: "2015-10-16", end: "2015-10-18", url: ""},
          %{title: "foo", start: "2015-10-21T12:00:00", end: "", url: ""},
          %{title: "bar", start: "2015-10-22T12:00:00", end: "2015-10-25T15:00:00", url: ""}]

for event <- events do
  Event.changeset(%Event{}, event) |> Repo.insert!
end