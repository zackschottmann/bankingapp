/// Author: Zackary Schottmann
/// Description: Defines a Transaction model with properties such as 
/// name, amount, type, description, and date for managing transaction data.
library;

class Transaction {
  final String fromAccount;
  final String toAccount;
  final double amount;
  final String description;
  final DateTime date; 

  Transaction({
    required this.fromAccount,
    required this.toAccount,
    required this.amount,
    required this.description,
    required this.date,
  });

  @override
  String toString() {
    return 'Transaction(from: $fromAccount, to: $toAccount, amount: \$${amount.toStringAsFixed(2)}, description: $description, date: $date)';
  }
}
