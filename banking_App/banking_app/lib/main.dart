import 'package:flutter/material.dart';
import 'add_transaction_page.dart';

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
/// Description: Implements tab navigation for Checking, Savings, and Credit accounts,
/// sharing state for balances and transactions across tabs.
class AccountHomePage extends StatefulWidget {
  @override
  _AccountHomePageState createState() => _AccountHomePageState();
}

class _AccountHomePageState extends State<AccountHomePage> {
  final Map<String, List<Map<String, String>>> transactions = {
    'Chequeing': [
      {'date': '2024-11-20', 'desc': 'Groceries', 'amount': '-\$45.00'},
      {'date': '2024-11-18', 'desc': 'Salary', 'amount': '+\$1500.00'},
    ],
    'Savings': [
      {'date': '2024-11-15', 'desc': 'Transfer to Checking', 'amount': '-\$500.00'},
      {'date': '2024-11-10', 'desc': 'Interest Credit', 'amount': '+\$20.00'},
    ],
    'Credit': [
      {'date': '2024-11-14', 'desc': 'Online Purchase', 'amount': '-\$200.00'},
      {'date': '2024-11-11', 'desc': 'Payment Received', 'amount': '+\$400.00'},
    ],
  };

  final Map<String, double> balances = {
    'Chequeing': 2500.75,
    'Savings': 8000.50,
    'Credit': -1200.00,
  };

  // Method to add a transaction and update the balance
  void addTransaction(String accountType, Map<String, String> transaction, double amount) {
    setState(() {
      transactions[accountType]!.add(transaction);
      balances[accountType] = balances[accountType]! + amount;
    });
  }

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
        body: TabBarView(
          children: [
            AccountPage(
              accountType: 'Chequeing',
              transactions: transactions['Chequeing']!,
              balance: balances['Chequeing']!,
              addTransaction: addTransaction,
            ),
            AccountPage(
              accountType: 'Savings',
              transactions: transactions['Savings']!,
              balance: balances['Savings']!,
              addTransaction: addTransaction,
            ),
            AccountPage(
              accountType: 'Credit',
              transactions: transactions['Credit']!,
              balance: balances['Credit']!,
              addTransaction: addTransaction,
            ),
          ],
        ),
      ),
    );
  }
}

/// Author: Zackary Schottmann
/// Description: Displays the balance and transactions for a specific account type,
/// with the ability to add new transactions and update the balance.
class AccountPage extends StatelessWidget {
  final String accountType;
  final double balance;
  final List<Map<String, String>> transactions;
  final Function(String accountType, Map<String, String> transaction, double amount) addTransaction;

  const AccountPage({
    Key? key,
    required this.accountType,
    required this.balance,
    required this.transactions,
    required this.addTransaction,
  }) : super(key: key);

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
                '$accountType Account',
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTransactionPage()),
              );

              if (result != null) {
                final newTransaction = {
                  'date': DateTime.now().toString().split(' ')[0],
                  'desc': result['name'] as String,
                  'amount': (result['amount'] > 0
                      ? '+\$${result['amount'].toStringAsFixed(2)}'
                      : '-\$${(result['amount'].abs()).toStringAsFixed(2)}'),
                };

                addTransaction(accountType, newTransaction, result['amount']);
              }
            },
            child: Text('Add Transaction'),
          ),
        ),
      ],
    );
  }
}
