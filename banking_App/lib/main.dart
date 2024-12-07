import 'package:flutter/material.dart';
import 'add_transaction_page.dart';
import 'interac_payment_page.dart';
import 'atm_map_page.dart';

void main() {
  runApp(const BankingApp());
}

/// Author: Harsh Patel
/// Description: Entry point for the banking app with tab navigation and account details.
class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banking App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AccountHomePage(),
    );
  }
}

/// Author: Harsh Patel
/// Description: Implements tab navigation for Chequeing, Savings, and Credit accounts.
class AccountHomePage extends StatefulWidget {
  const AccountHomePage({super.key});

  @override
  _AccountHomePageState createState() => _AccountHomePageState();
}

class _AccountHomePageState extends State<AccountHomePage> {
  final Map<String, List<Map<String, String>>> transactions = {
    'Chequeing': [],
    'Savings': [],
    'Credit': [],
  };

  final Map<String, double> balances = {
    'Chequeing': 1000.0,
    'Savings': 5000.0,
    'Credit': -1200.0,
  };

  /// Author: Zackary Schottmann
  /// Description: Handles adding transactions by transferring money
  /// between Chequeing and Savings accounts, ensuring the source account doesn't go below zero.
  void addTransaction(
      String fromAccount, String toAccount, double amount, String description) {
    if (balances[fromAccount]! >= amount) {
      setState(() {
        transactions[fromAccount]!.add({
          'date': DateTime.now().toString().split(' ')[0],
          'desc': 'Transfer to $toAccount: $description',
          'amount': '-\$${amount.toStringAsFixed(2)}',
        });
        balances[fromAccount] = balances[fromAccount]! - amount;

        transactions[toAccount]!.add({
          'date': DateTime.now().toString().split(' ')[0],
          'desc': 'Transfer from $fromAccount: $description',
          'amount': '+\$${amount.toStringAsFixed(2)}',
        });
        balances[toAccount] = balances[toAccount]! + amount;
      });
    } else {
      _showErrorDialog(
        context,
        'Insufficient Funds',
        'The $fromAccount account does not have enough balance.',
      );
    }
  }

  /// Author: Zackary Schottmann
  /// Description: Handles paying the credit card from either Chequeing or Savings,
  /// ensuring the selected account doesn't go below zero.
  void payCreditCard(String fromAccount, double amount) {
    if (balances[fromAccount]! >= amount) {
      setState(() {
        transactions[fromAccount]!.add({
          'date': DateTime.now().toString().split(' ')[0],
          'desc': 'Credit Card Payment',
          'amount': '-\$${amount.toStringAsFixed(2)}',
        });
        balances[fromAccount] = balances[fromAccount]! - amount;

        transactions['Credit']!.add({
          'date': DateTime.now().toString().split(' ')[0],
          'desc': 'Payment Received from $fromAccount',
          'amount': '+\$${amount.toStringAsFixed(2)}',
        });
        balances['Credit'] = balances['Credit']! + amount;
      });
    } else {
      _showErrorDialog(
        context,
        'Insufficient Funds',
        'The $fromAccount account does not have enough balance to pay the credit card.',
      );
    }
  }

  /// Author: Zackary Schottmann
  /// Description: Handles depositing money into a specified account with a description.
  void deposit(String account, double amount, String description) {
    setState(() {
      transactions[account]!.add({
        'date': DateTime.now().toString().split(' ')[0],
        'desc': 'Deposit: $description',
        'amount': '+\$${amount.toStringAsFixed(2)}',
      });
      balances[account] = balances[account]! + amount;
    });
  }
  ///Author: Harsh Patel
  void sendInterac(String account, double amount, String recipient) {
    setState(() {
      balances[account] = balances[account]! - amount;
      transactions[account]!.add({
        'date': DateTime.now().toString().split(' ')[0],
        'desc': 'Sent Interac to $recipient',
        'amount': '-\$${amount.toStringAsFixed(2)}',
      });
    });
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Banking App'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.account_balance_wallet), text: 'Chequeing'),
              Tab(icon: Icon(Icons.savings), text: 'Savings'),
              Tab(icon: Icon(Icons.credit_card), text: 'Credit'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ATMMapPage()),
                );
               },
               tooltip: 'View Nearby ATMs',
             ),
          ],
        ),
        body: TabBarView(
          children: [
            AccountPage(
              accountType: 'Chequeing',
              transactions: transactions['Chequeing']!,
              balance: balances['Chequeing']!,
              balances: balances,
              onSendInterac: (account, amount, recipient) =>
                  sendInterac(account, amount, recipient),
              onAddTransaction: (toAccount, amount, description) =>
                  addTransaction('Chequeing', toAccount, amount, description),
              onDeposit: (amount, description) =>
                  deposit('Chequeing', amount, description),
            ),
            AccountPage(
              accountType: 'Savings',
              transactions: transactions['Savings']!,
              balance: balances['Savings']!,
              balances: balances,
              onAddTransaction: (toAccount, amount, description) =>
                  addTransaction('Savings', toAccount, amount, description),
              onDeposit: (amount, description) =>
                  deposit('Savings', amount, description),
            ),
            AccountPage(
              accountType: 'Credit',
              transactions: transactions['Credit']!,
              balance: balances['Credit']!,
              balances: balances,
              onPayCreditCard: (fromAccount, amount) =>
                  payCreditCard(fromAccount, amount),
            ),
          ],
        ),
      ),
    );
  }
}

/// Author: Zackary Schottmann
/// Description: Represents an account page with options for adding transactions,
/// making deposits, or paying the credit card depending on the account type.
class AccountPage extends StatelessWidget {
  final String accountType;
  final double balance;
  final Map<String, double> balances;
  final List<Map<String, String>> transactions;
    final void Function(String account, double amount, String recipient)?
      onSendInterac;
  final void Function(String toAccount, double amount, String description)?
      onAddTransaction;
  final void Function(double amount, String description)? onDeposit;
  final void Function(String fromAccount, double amount)? onPayCreditCard;

  const AccountPage({
    super.key,
    required this.accountType,
    required this.balance,
    required this.balances,
    required this.transactions,
    this.onSendInterac,
    this.onAddTransaction,
    this.onDeposit,
    this.onPayCreditCard,
  });

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// Author: Zackary Schottmann
  /// Description: Builds the account page UI with transaction list and action buttons.
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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
       if (accountType != 'Credit') 
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InteracPaymentPage(balances: balances),
                ),
              );

              if (result != null && result is Map) {
                final account = result['account'] as String;
                final amount = result['amount'] as double;
                final recipient = result['recipient'] as String;

                if (onSendInterac != null) {
                  onSendInterac!(account, amount, recipient);
                }
              }
            },
            child: const Text('Send Interac Payment'),
          ),
        ),

        if (onAddTransaction != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddTransactionPage()),
                );

                if (result != null &&
                    result.containsKey('toAccount') &&
                    result.containsKey('amount') &&
                    result.containsKey('description')) {
                  final String toAccount = result['toAccount'] as String;
                  final double amount =
                      double.tryParse(result['amount'].toString()) ?? 0.0;
                  final String description = result['description'] as String;

                  if (amount > 0 && (toAccount == 'Chequeing' || toAccount == 'Savings')) {
                    if (toAccount != accountType) {
                      onAddTransaction!(toAccount, amount, description);
                    } else {
                      _showErrorDialog(
                        context,
                        'Invalid Transaction',
                        'Cannot transfer to the same account.',
                      );
                    }
                  } else {
                    _showErrorDialog(
                      context,
                      'Invalid Transaction',
                      'Please ensure the transaction details are correct.',
                    );
                  }
                } else {
                  _showErrorDialog(
                    context,
                    'Incomplete Data',
                    'Please fill in all fields for the transaction.',
                  );
                }
              },
              child: const Text('Transfer funds'),
            ),
          ),
        if (onDeposit != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final depositAmount =
                    await _getAmountFromUser(context, 'Deposit Amount');
                final depositDescription =
                    await _getDescriptionFromUser(context, 'Deposit Description');
                if (depositAmount != null &&
                    depositAmount > 0 &&
                    depositDescription != null &&
                    depositDescription.isNotEmpty) {
                  onDeposit!(depositAmount, depositDescription);
                } else {
                  _showErrorDialog(
                    context,
                    'Invalid Deposit',
                    'Please enter a valid amount and description.',
                  );
                }
              },
              child: const Text('Deposit'),
            ),
          ),
        if (onPayCreditCard != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final fromAccount = await _getAccountFromUser(context);
                if (fromAccount != null) {
                  final paymentAmount = await _getAmountFromUser(
                      context, 'Pay Credit Card from $fromAccount');
                  if (paymentAmount != null && paymentAmount > 0) {
                    onPayCreditCard!(fromAccount, paymentAmount);
                  } else {
                    _showErrorDialog(
                      context,
                      'Invalid Payment',
                      'Please enter a valid payment amount.',
                    );
                  }
                }
              },
              child: const Text('Pay Credit Card'),
            ),
          ),
      ],
    );
  }

  Future<double?> _getAmountFromUser(
      BuildContext context, String title) async {
    final controller = TextEditingController();
    return showDialog<double>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter amount'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(controller.text);
                Navigator.pop(context, amount);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _getDescriptionFromUser(
      BuildContext context, String title) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter description'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _getAccountFromUser(BuildContext context) async {
    String selectedAccount = 'Chequeing';
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Account'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                value: selectedAccount,
                items: ['Chequeing', 'Savings']
                    .map((account) => DropdownMenuItem(
                          value: account,
                          child: Text(account),
                        ))
                    .toList(),
                onChanged: (value) => setState(() {
                  selectedAccount = value!;
                }),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, selectedAccount),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
