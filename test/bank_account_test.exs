defmodule BankAccountTest do
  use ExUnit.Case

  test "Initial balance zero" do
    pid = spawn(BankAccount, :start, [])
    Process.send(pid, { :send_balance, self }, [])
    assert_receive { :balance, 0 }
  end

  test "Can deposit moneys" do
    pid = spawn(BankAccount, :start, [])
    Process.send(pid, { :deposit, 50 }, [])
    Process.send(pid, { :send_balance, self }, [])

    assert_receive { :balance, 50 }
  end

  test "Can withdraw moneys" do
    pid = spawn(BankAccount, :start, [])
    Process.send(pid, { :deposit, 100 }, [])
    Process.send(pid, { :withdraw, 50 }, [])
    Process.send(pid, { :send_balance, self }, [])

    assert_receive { :balance, 50 }
  end

  # test "No moneys no withdraw" do
  #   pid = spawn(BankAccount, :start, [])
  #   Process.send(pid, { :deposit, 50 }, [])
  #   Process.send(pid, { :withdraw, 100 }, [])
  #   Process.send(pid, { :send_balance, self }, [])
  #   assert_receive { :balance, 50 }
  # end

  # test "No deposit negative moneys" do
  #   pid = spawn(BankAccount, :start, [])
  #   Process.send(pid, { :deposit, 100 }, [])
  #   Process.send(pid, { :deposit, -50 }, [])
  #   Process.send(pid, { :send_balance, self }, [])
  #   assert_receive { :balance, 100 }
  # end

  # test "No withdraw negative moneys" do
  #   pid = spawn(BankAccount, :start, [])
  #   Process.send(pid, { :deposit, 100 }, [])
  #   Process.send(pid, { :withdraw, -50 }, [])
  #   Process.send(pid, { :send_balance, self }, [])
  #   assert_receive { :balance, 100 }
  # end

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
