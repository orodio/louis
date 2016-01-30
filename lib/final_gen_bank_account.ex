defmodule FinalGenBankAccount do
  use GenServer

  def start_link, do: start_link []
  def start_link(history) do
    { :ok, pid } = GenServer.start_link(FinalGenBankAccount, history)
    pid
  end

  def send_balance(account_pid, pid), do: cast(account_pid, { :send_balance, pid })
  def deposit(account_pid, amount),   do: cast(account_pid, { :deposit, amount })
  def withdraw(account_pid, amount),  do: cast(account_pid, { :withdraw, amount })

  ## private stuff
  def handle_cast({ :send_balance, pid }, history) do
    send_message(pid, { :balance, calc_balance(history) })
    { :noreply, history }
  end

  def handle_cast(event = { :deposit, amount }, history) when amount >= 0  do
    { :noreply, [ event | history ] }
  end

  def handle_cast(event = { :withdraw, amount }, history) when amount >= 0 do
    if calc_balance(history) >= amount do
      { :noreply, [ event | history ] }
    else
      { :noreply, history }
    end
  end

  def handle_cast(_event, history), do: { :noreply, history }

  ## helpers
  def calc_balance(history), do: Enum.reduce(history, 0, &balance_reducer/2)

  defp balance_reducer({ :deposit, amount }, acc),  do: acc + amount
  defp balance_reducer({ :withdraw, amount }, acc), do: acc - amount
  defp balance_reducer(_event, acc),                do: acc

  defp cast(pid, msg) do
    GenServer.cast(pid, msg) # returns :"$gen_cast"
    pid
  end

  defp send_message(pid, msg) do
    Process.send(pid, msg, []) # returns :ok
    pid
  end
end

