import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'transaction.dart';

class Block {
  int index;
  DateTime timestamp;
  List<Transaction> transactions;
  String previousHash;
  String hash;

  Block(this.index, this.timestamp, this.transactions, this.previousHash,
      this.hash) {
    hash = computeHash();
  }

  // Hash computation method
  String computeHash() {
    String txInfo = transactions
        .map((Transaction tx) => tx.sender + tx.receiver + tx.amount.toString())
        .join();
    return sha256
        .convert(utf8.encode(
            index.toString() + timestamp.toString() + previousHash + txInfo))
        .toString();
  }
}

Block createGenesisBlock() {
  return Block(0, DateTime.now(), [], "0", "");
}

Block nextBlock(Block lastBlock, List<Transaction> transactions) {
  int thisIndex = lastBlock.index + 1;
  DateTime timestamp = DateTime.now();
  String thisHash = lastBlock.hash;
  return Block(thisIndex, timestamp, transactions, thisHash, "");
}
