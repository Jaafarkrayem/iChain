import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'transaction.dart';

class P2PScreen extends StatefulWidget {
  @override
  _P2PScreenState createState() => _P2PScreenState();
}

class _P2PScreenState extends State<P2PScreen> {
  final _formKey = GlobalKey<FormState>();
  String _sender = '';
  String _receiver = '';
  double _amount = 0.0;

  @override
  Widget build(BuildContext context) {
    // TransactionPool transactionPool = Provider.of<TransactionPool>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('P2P Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Sender'),
                onSaved: (value) => _sender = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Receiver'),
                onSaved: (value) => _receiver = value ?? '',
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
                onSaved: (value) => _amount = double.parse(value ?? '0'),
              ),
              ElevatedButton(
                onPressed: makeTransaction,
                child: Text('Make Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void makeTransaction() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Transaction transaction = Transaction(_sender, _receiver, _amount);

      TransactionPool transactionPool =
          Provider.of<TransactionPool>(context, listen: false);
      transactionPool.add(transaction);

      Navigator.pop(context);
    }
  }
}
