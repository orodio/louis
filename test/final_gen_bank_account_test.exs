defmodule FinalGenBankAccountTest do
  use ExUnit.Case
  alias FinalGenBankAccount, as: BA

  test "Initial balance zero" do
    BA.start_link
    |> BA.send_balance(self)

    assert_receive { :balance, 0 }
  end

  test "Can deposit moneys" do
    BA.start_link
    |> BA.deposit(50)
    |> BA.send_balance(self)

    assert_receive { :balance, 50 }
  end

  test "Can withdraw moneys" do
    BA.start_link
    |> BA.deposit(100)
    |> BA.withdraw(50)
    |> BA.send_balance(self)

    assert_receive { :balance, 50 }
  end

  test "No moneys no withdraw" do
    BA.start_link
    |> BA.deposit(50)
    |> BA.withdraw(100)
    |> BA.send_balance(self)

    assert_receive { :balance, 50 }
  end

  test "No deposit negative moneys" do
    BA.start_link
    |> BA.deposit(100)
    |> BA.deposit(-50)
    |> BA.send_balance(self)

    assert_receive { :balance, 100 }
  end

  test "No withdraw negative moneys" do
    BA.start_link
    |> BA.deposit(100)
    |> BA.withdraw(-50)
    |> BA.send_balance(self)

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

    assert -10 == BA.calc_balance(history)
  end
end


