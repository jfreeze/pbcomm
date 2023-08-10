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
  def connect do
    Node.connect(:"mbp@192.168.100.172")
  end
end
