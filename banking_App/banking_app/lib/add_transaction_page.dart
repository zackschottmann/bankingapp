import 'package:flutter/material.dart';

/// Author: Zackary Schottmann
/// Description: Provides a form to add a transaction, specifying the target account,
/// amount, and description.

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String? _toAccount; 
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _submitTransaction() {
    if (_toAccount == null ||
        _amountController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      _showErrorDialog(
        'Incomplete Fields',
        'Please fill in all fields before submitting the transaction.',
      );
      return;
    }

    final double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showErrorDialog(
        'Invalid Amount',
        'Please enter a valid amount greater than zero.',
      );
      return;
    }

    Navigator.pop(context, {
      'toAccount': _toAccount,
      'amount': amount,
      'description': _descriptionController.text.trim(),
    });
  }

  void _showErrorDialog(String title, String message) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              isExpanded: true,
              value: _toAccount,
              items: ['Chequeing', 'Savings']
                  .map(
                    (account) => DropdownMenuItem(
                      value: account,
                      child: Text(account),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _toAccount = value;
                });
              },
              hint: const Text('Select an account'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter the amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter a description for the transaction',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitTransaction,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
