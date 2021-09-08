class Transaction {
  final double value;
  final int account;

  Transaction(
    this.value,
    this.account,
  );

  @override
  String toString() {
    return 'Transaction{value: $value, account: $account}';
  }
}
