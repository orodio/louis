defmodule BankAccount do
  def start, do: await []

  def await(history) do
    receive do
      event -> await handle_event(event, history)
    end
  end

  ## handlers
  def handle_event({ :send_balance, pid }, history) do
    Process.send(pid, { :balance, calc_balance(history) }, [])
    history
  end

  def handle_event(event = { :deposit,  _ }, history) do
    [ event | history ]
  end

  def handle_event(event = { :withdraw, _ }, history) do
    [ event | history ]
  end

  def handle_event(_event, history), do: history

  ## helpers
  def calc_balance(history), do: Enum.reduce(history, 0, &balance_reducer/2)

  defp balance_reducer({ :deposit, amount }, acc),  do: acc + amount
  defp balance_reducer({ :withdraw, amount }, acc), do: acc - amount
  defp balance_reducer(_event, acc),                do: acc
end
