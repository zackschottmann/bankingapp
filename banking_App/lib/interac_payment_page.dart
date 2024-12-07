//Author : Harsh Patel 
//Description: Interac payment page for sending money to another user which sends info back to main.dart and update the balances.
import 'package:flutter/material.dart';

class InteracPaymentPage extends StatefulWidget {
  final Map<String, double> balances;

  const InteracPaymentPage({super.key, required this.balances});

  @override
  _InteracPaymentPageState createState() => _InteracPaymentPageState();
}

class _InteracPaymentPageState extends State<InteracPaymentPage> {
  String? _selectedAccount;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Interac Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedAccount,
              hint: const Text('Select Account'),
              onChanged: (value) {
                setState(() {
                  _selectedAccount = value;
                });
              },
              items: widget.balances.keys.map((account) {
                return DropdownMenuItem<String>(
                  value: account,
                  child: Text(account),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _recipientController,
              decoration: const InputDecoration(
                labelText: 'Recipient Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Submit button
            ElevatedButton(
              onPressed: () {
                if (_selectedAccount == null) {
                  _showErrorDialog('Please select an account.');
                  return;
                }
                if (_recipientController.text.isEmpty) {
                  _showErrorDialog('Please enter a recipient email.');
                  return;
                }
                if (_amountController.text.isEmpty) {
                  _showErrorDialog('Please enter an amount.');
                  return;
                }

                double paymentAmount = double.parse(_amountController.text);
                String selectedAccount = _selectedAccount!;
                String recipient = _recipientController.text;

                if (widget.balances[selectedAccount]! >= paymentAmount) {
                  Navigator.pop(context, {
                    'account': selectedAccount,
                    'amount': paymentAmount,
                    'recipient': recipient,
                  });
                } else {
                  _showErrorDialog('Insufficient funds in the selected account.');
                }
              },
              child: const Text('Send Payment'),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
