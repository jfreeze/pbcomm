defmodule Pbcomm.Message do
  use GenServer

  @check_interval 1000

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def paste do
    payload = execute({"pbpaste", []})
    Phoenix.PubSub.broadcast_from(Pbcomm.PubSub, self(), "messages", {:paste, self(), payload})
    # Phoenix.PubSub.broadcast(Pbcomm.PubSub, "messages", {:paste, self(), payload})
  end

  def init(_) do
    Phoenix.PubSub.subscribe(Pbcomm.PubSub, "messages")
    payload = execute({"pbpaste", []})
    schedule_check()
    {:ok, %{payload: payload}}
  end

  def handle_info({:paste, _pid, payload}, state) do
    IO.puts(payload)

    execute({"pbcopy", []}, payload)

    {:noreply, state}
  end

  def handle_info(:check_pbpaste, %{payload: last_payload} = state) do
    payload = execute({"pbpaste", []})

    new_state =
      if payload != last_payload do
        Phoenix.PubSub.broadcast_from(
          Pbcomm.PubSub,
          self(),
          "messages",
          {:paste, self(), payload}
        )

        %{payload: payload}
      else
        state
      end

    schedule_check()
    {:noreply, new_state}
  end

  # Ignore port closure
  def handle_info(_event, state) do
    {:noreply, state}
  end

  defp schedule_check do
    Process.send_after(self(), :check_pbpaste, @check_interval)
  end

  defp execute({executable, args}) when is_binary(executable) and is_list(args) do
    case System.find_executable(executable) do
      nil ->
        {:error, "Cannot find #{executable}"}

      _ ->
        case System.cmd(executable, args) do
          {output, 0} ->
            output

          {error, _} ->
            {:error, error}
        end
    end
  end

  defp execute({executable, args}, value) when is_binary(executable) and is_list(args) do
    case System.find_executable(executable) do
      nil ->
        {:error, "Cannot find #{executable}"}

      path ->
        port = Port.open({:spawn_executable, path}, [:binary, args: args])

        case value do
          value when is_binary(value) ->
            send(port, {self(), {:command, value}})

          value ->
            send(port, {self(), {:command, format(value)}})
        end

        send(port, {self(), :close})
        :ok
    end
  end

  defp format(value) do
    doc = Inspect.Algebra.to_doc(value, %Inspect.Opts{limit: :infinity})
    Inspect.Algebra.format(doc, :infinity)
  end
end
