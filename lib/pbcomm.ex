defmodule Pbcomm do
  @moduledoc """
  Documentation for `Pbcomm`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Pbcomm.hello()
      :world

  """
  def connect(name) do
    Node.connect(String.to_atom(name))
  end
end
