import 'package:flutter/material.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/transaction/form.dart';

const _titleAppBar = 'Transferências';

class TransactionList extends StatefulWidget {
  final List<Transaction> _transactions = [];

  @override
  State<StatefulWidget> createState() {
    return TransactionsListState();
  }
}

class TransactionsListState extends State<TransactionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body: ListView.builder(
        itemCount: widget._transactions.length,
        itemBuilder: (context, index) {
          final transaction = widget._transactions[index];
          return TransactionItem(transaction);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TransactionForm();
          })).then((transaction) => _updateTransaction(transaction));
        },
      ),
    );
  }

  void _updateTransaction(Transaction? transaction) {
    if (transaction != null) {
      setState(() {
        widget._transactions.add(transaction);
      });
    }
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction _transaction;

  TransactionItem(this._transaction);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(_transaction.value.toString()),
        subtitle: Text(_transaction.account.toString()),
      ),
    );
  }
}
