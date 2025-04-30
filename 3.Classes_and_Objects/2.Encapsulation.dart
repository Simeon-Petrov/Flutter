class BankAccount {
  String _accountNumber;
  double _balance;

  BankAccount(this._accountNumber, this._balance);

  double get balance {
    //  double get balance => _balance;
    return _balance;
  }

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print("Deposited  is \$${amount.toStringAsFixed(2)}");
    } else {
      print("Deposited  amout must be greater than zero.}");
    }
  }

  void withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      print("Withdraw: \$${amount.toStringAsFixed(2)}");
    } else if (amount > _balance) {
      print("Insufficient funds for withdrawal.");
    } else {
      print("Withdrawal amount must be greater than zero.");
    }
  }
}

void main() {
  var account = BankAccount('123456789', 500.00);

  print('Initial Balance: \$${account.balance.toStringAsFixed(2)}');

  account.deposit(150.00);
  print('Balance after deposit: \$${account.balance.toStringAsFixed(2)}');

  account.withdraw(100.00);
  print('Balance after withdrawal: \$${account.balance.toStringAsFixed(2)}');

  //account.withdraw(66.00);
}
