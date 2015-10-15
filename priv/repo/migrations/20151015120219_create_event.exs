defmodule FullCarendarSample.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :start, :string
      add :end, :string
      add :url, :string

      timestamps
    end

  end
end
