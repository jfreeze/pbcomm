defmodule Pbcomm do
  @moduledoc """
  Documentation for `Pbcomm`.
  """

  @doc """
  Connect to a node
  """
  def connect(name) do
    Node.connect(String.to_atom(name))
  end

  def connect do
    connect(System.get_env("PB_NODE"))
  end
end
