// import 'dart:convert';
// import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'block.dart';
import 'blockchainscreen.dart';
import 'transaction.dart';
import 'walletcreationscreen.dart';
import 'wallet.dart';

void main() {
  List<Block> blockchain = [createGenesisBlock()];
  Wallet wallet = Wallet();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionPool()),
        Provider.value(value: blockchain),
      ],
      child: MaterialApp(
        title: 'iChain',
        home: BlockchainScreen(blockchain: blockchain, wallet: wallet),
        routes: {
          '/createWallet': (context) => WalletCreationScreen(),
        },
      ),
    ),
  );
}
