defmodule FullCarendarSample.Event do
  use FullCarendarSample.Web, :model

  schema "events" do
    field :title, :string
    field :start, :string
    field :end, :string
    field :url, :string

    timestamps
  end

  @required_fields ~w(title start)
  @optional_fields ~w(end url)
  @derive [Poison.Encoder]

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def to_events_data_format(events) when is_list(events) do
    Enum.reduce(events, [], fn(event, acc) -> acc ++ [to_event_data_format(event)] end)
  end

  defp to_event_data_format(event) when is_map(event) do
    %{title: event.title, start: event.start, end: event.end, url: event.url}
  end
end
