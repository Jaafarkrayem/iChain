import 'dart:collection';
import 'package:flutter/foundation.dart';

class Transaction {
  String sender;
  String receiver;
  double amount;

  Transaction(this.sender, this.receiver, this.amount);
}

class TransactionPool with ChangeNotifier {
  final List<Transaction> _pendingTransactions = [];

  UnmodifiableListView<Transaction> get pendingTransactions =>
      UnmodifiableListView(_pendingTransactions);

  void add(Transaction tx) {
    _pendingTransactions.add(tx);
    notifyListeners();
  }

  void clear() {
    _pendingTransactions.clear();
    notifyListeners();
  }
}
