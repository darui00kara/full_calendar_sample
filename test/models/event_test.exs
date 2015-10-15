defmodule FullCarendarSample.EventTest do
  use FullCarendarSample.ModelCase

  alias FullCarendarSample.Event

  @valid_attrs %{end: "some content", start: "some content", title: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end
