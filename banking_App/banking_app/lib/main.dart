import 'package:flutter/material.dart';

void main() {
  runApp(BankingApp());
}

/// Author: Harsh Patel
/// Description: Entry point for the banking app with tab navigation and account details.
class BankingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banking App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AccountHomePage(),
    );
  }
}

/// Author: Harsh Patel
/// Description: Implements tab navigation for Checking, Savings, and Credit accounts.
class AccountHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Three tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Banking App'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.account_balance_wallet), text: 'Chequeing'),
              Tab(icon: Icon(Icons.savings), text: 'Savings'),
              Tab(icon: Icon(Icons.credit_card), text: 'Credit'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AccountPage(
              accountType: 'Chequeing',
              initialBalance: 2500.75,
              initialTransactions: [
                {'date': '2024-11-20', 'desc': 'Groceries', 'amount': '-\$45.00'},
                {'date': '2024-11-18', 'desc': 'Salary', 'amount': '+\$1500.00'},
              ],
            ),
            AccountPage(
              accountType: 'Savings',
              initialBalance: 8000.50,
              initialTransactions: [
                {'date': '2024-11-15', 'desc': 'Transfer to Checking', 'amount': '-\$500.00'},
                {'date': '2024-11-10', 'desc': 'Interest Credit', 'amount': '+\$20.00'},
              ],
            ),
            AccountPage(
              accountType: 'Credit',
              initialBalance: -1200.00,
              initialTransactions: [
                {'date': '2024-11-14', 'desc': 'Online Purchase', 'amount': '-\$200.00'},
                {'date': '2024-11-11', 'desc': 'Payment Received', 'amount': '+\$400.00'},
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Author: Harsh Patel
/// Description: Displays the balance and transactions for a specific account type with dynamic updates using a stateful widget.
class AccountPage extends StatefulWidget {
  final String accountType;
  final double initialBalance;
  final List<Map<String, String>> initialTransactions;

  const AccountPage({
    Key? key,
    required this.accountType,
    required this.initialBalance,
    required this.initialTransactions,
  }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late double balance;
  late List<Map<String, String>> transactions;

  @override
  void initState() {
    super.initState();
    balance = widget.initialBalance;
    transactions = List.from(widget.initialTransactions);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          color: Colors.blue.shade50,
          child: Column(
            children: [
              Text(
                '${widget.accountType} Account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Balance: \$${balance.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: balance < 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(transaction['desc']!),
                  subtitle: Text(transaction['date']!),
                  trailing: Text(
                    transaction['amount']!,
                    style: TextStyle(
                      color: transaction['amount']!.startsWith('-')
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
