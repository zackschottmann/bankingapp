/// Author: Zackary Schottmann
/// Description: Defines a Transaction model with properties 
/// such as name, amount, type, and date for managing transaction data.

class Transaction {
  final String name;
  final double amount;
  final String type;
  final DateTime date;

  Transaction({
    required this.name,
    required this.amount,
    required this.type,
    required this.date,
  });
}
