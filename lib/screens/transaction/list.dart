import 'package:flutter/material.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/http/clients/transaction.dart';
import 'package:bytebank/components/centered_message.dart';
import 'package:bytebank/components/loading.dart';

class TransactionsList extends StatelessWidget {
  final TransactionApiClient _apiClient = TransactionApiClient();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _apiClient.getAllTransactions(),
        builder: (context, snapshot) {
          final List<Transaction>? transactions = snapshot.data;

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              return Loading(message: 'Loading...');
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                if (transactions != null && transactions.isNotEmpty) {
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final Transaction transaction = transactions[index];
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.monetization_on),
                          title: Text(
                            transaction.value.toString(),
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            transaction.contact.accountNumber.toString(),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      );
                    },
                  );
                }
              }
              return CenteredMessage(
                'No transactions found.',
                icon: Icons.warning,
              );
            default:
          }

          return CenteredMessage('Unknown error.');
        },
      ),
    );
  }
}
