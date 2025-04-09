import 'dart:vmservice_io';

class BankAccount {
  String _accountNumber;
  double _balance;

  BankAccount(this._accountNumber, this._balance);

  //geter
  double get balance => _balance;

  //method to deposit amount
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print("Deposited: \$${amount.toStringAsFixed(2)}");
    } else {
      print("Deposit amount must be greater than zero.");
    }
  }

  //withdraw
  void withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      print("Withdraw: \$${amount.toStringAsFixed(2)}");
    } else {
      print("Withdrawal amount must be greater than zero.");
    }
  }
}

void main() {
  var account = BankAccount("BG12BANK0000123456", 500.00);

  print("Initial Balance: \$${account.balance.toStringAsFixed(2)}");

  // deposit
  account.deposit(77.00);
  print("Balance after deposit: \$${account.balance.toStringAsFixed(2)}");

  //withdraw
  account.withdraw(13.00);
  print("Balance after withdraw: \$${account.balance.toStringAsFixed(2)}");

  //account.withdraw(600.00);
}
