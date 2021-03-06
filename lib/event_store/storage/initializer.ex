defmodule EventStore.Storage.Initializer do
  @moduledoc false

  alias EventStore.Sql.Statements

  def run!(event_store, config, conn, opts \\ []) do
    statements = Statements.initializers(event_store, config)

    execute!(conn, statements, opts)
  end

  def reset!(conn, opts \\ []) do
    statements = Statements.reset()

    execute!(conn, statements, opts)
  end

  defp execute!(conn, statements, opts) do
    Postgrex.transaction(
      conn,
      fn transaction ->
        Enum.each(statements, &query!(transaction, &1, opts))
      end,
      opts
    )
  end

  defp query!(conn, statement, opts) do
    Postgrex.query!(conn, statement, [], opts)
  end
end
