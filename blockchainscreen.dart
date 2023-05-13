import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ichain/wallet.dart';
import 'package:provider/provider.dart';
import 'block.dart';
import 'p2pscreen.dart';
import 'transaction.dart';
import 'wallet.dart';

class BlockchainScreen extends StatefulWidget {
  final List<Block> blockchain;
  final Wallet wallet;

  const BlockchainScreen(
      {Key? key, required this.blockchain, required this.wallet})
      : super(key: key);

  @override
  BlockchainScreenState createState() =>
      BlockchainScreenState(blockchain, wallet);
}

class BlockchainScreenState extends State<BlockchainScreen> {
  List<Block> blockchain;
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  BlockchainScreenState(this.blockchain, Wallet wallet) {
    _timer = Timer.periodic(Duration(seconds: 6), (Timer t) => addBlock());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iChain'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => P2PScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: blockchain.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Block #${blockchain[index].index}'),
            subtitle: Text(
                'Data: ${blockchain[index].transactions.map((tx) => '${tx.sender} sent ${tx.amount} ISLAMI to ${tx.receiver}').join('\n')}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createWallet');
        },
        tooltip: 'Create Wallet',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void addBlock() {
    setState(() {
      TransactionPool txPool =
          Provider.of<TransactionPool>(context, listen: false);
      Block newBlock =
          nextBlock(blockchain.last, txPool.pendingTransactions.toList());
      blockchain.add(newBlock);
      _scrollToBottom();
      TransactionPool transactionPool =
          Provider.of<TransactionPool>(context, listen: false);
      transactionPool.clear();
      print('Block #${newBlock.index} has been added to the blockchain!');
      print('Hash: ${newBlock.hash}\n');
    });
  }

  void _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }
}
