defmodule GenBankAccountTest do
  use ExUnit.Case
  alias GenBankAccount, as: BA

  test "Initial balance zero" do
    { :ok, pid } = GenServer.start_link(BA, [])
    GenServer.cast(pid, { :send_balance, self })
    assert_receive { :balance, 0 }
  end

  test "Can deposit moneys" do
    { :ok, pid } = GenServer.start_link(BA, [])
    GenServer.cast(pid, { :deposit, 50 })
    GenServer.cast(pid, { :send_balance, self })
    assert_receive { :balance, 50 }
  end

  test "Can withdraw moneys" do
    { :ok, pid } = GenServer.start_link(BA, [])
    GenServer.cast(pid, { :deposit, 100 })
    GenServer.cast(pid, { :withdraw, 50 })
    GenServer.cast(pid, { :send_balance, self })
    assert_receive { :balance, 50 }
  end

  test "No moneys no withdraw" do
    { :ok, pid } = GenServer.start_link(BA, [])
    GenServer.cast(pid, { :deposit, 50 })
    GenServer.cast(pid, { :withdraw, 100 })
    GenServer.cast(pid, { :send_balance, self })
    assert_receive { :balance, 50 }
  end

  test "No deposit negative moneys" do
    { :ok, pid } = GenServer.start_link(BA, [])
    GenServer.cast(pid, { :deposit, 100 })
    GenServer.cast(pid, { :deposit, -50 })
    GenServer.cast(pid, { :send_balance, self })
    assert_receive { :balance, 100 }
  end

  test "No withdraw negative moneys" do
    { :ok, pid } = GenServer.start_link(BA, [])
    GenServer.cast(pid, { :deposit, 100 })
    GenServer.cast(pid, { :withdraw, -50 })
    GenServer.cast(pid, { :send_balance, self })
    assert_receive { :balance, 100 }
  end

  test "#calc_balance" do
    history = [
      { :lol_wtf,  99 },
      { :deposit,  50 },
      { :deposit,  50 },
      { :withdraw, 50 },
      { :withdraw, 60 },
    ]

    assert -10 == BankAccount.calc_balance(history)
  end
end

