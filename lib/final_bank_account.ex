defmodule FinalBankAccount do
  ## public stuff
  def start_link, do: spawn(FinalBankAccount, :start, [])

  def send_balance(account_pid, pid), do: send_message(account_pid, { :send_balance, pid })
  def deposit(account_pid, amount),   do: send_message(account_pid, { :deposit, amount })
  def withdraw(account_pid, amount),  do: send_message(account_pid, { :withdraw, amount })

  ## private stuff
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

  def handle_event(event = { :deposit,  amount }, history) when amount >= 0 do
    [ event | history ]
  end

  def handle_event(event = { :withdraw, amount }, history) when amount >= 0 do
    if calc_balance(history) >= amount do
      [ event | history ]
    else
      history
    end
  end

  def handle_event(_event, history), do: history

  ## helpers
  def calc_balance(history), do: Enum.reduce(history, 0, &balance_reducer/2)

  defp balance_reducer({ :deposit, amount }, acc),  do: acc + amount
  defp balance_reducer({ :withdraw, amount }, acc), do: acc - amount
  defp balance_reducer(_event, acc),                do: acc

  defp send_message(pid, msg) do
    Process.send(pid, msg, []) # returns :ok
    pid
  end
end

