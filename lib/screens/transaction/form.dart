import 'dart:async';

import 'package:bytebank/components/loading.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:bytebank/http/clients/transaction.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionApiClient _apiClient = TransactionApiClient();
  final String transactionId = Uuid().v4();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('New transaction')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: _sending,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Loading(
                    message: 'Sending transaction...',
                  ),
                ),
              ),
              Text(
                widget.contact.fullName,
                style: TextStyle(fontSize: 24.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double? value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(transactionId, value, widget.contact);

                      showDialog(
                        context: context,
                        builder: (contextDialog) => TransactionAuthDialog(
                          onConfirm: (password) {
                            _save(transactionCreated, password, context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(Transaction transactionCreated, String password,
      BuildContext context) async {
    try {
      setState(() {
        _sending = true;
      });

      await _apiClient
          .saveTransaction(transactionCreated, password)
          .whenComplete(() => setState(() => _sending = false));

      showDialog(
        context: context,
        builder: (dialogContext) {
          return SuccessDialog('Transaction was transfered.');
        },
      ).then((value) => Navigator.pop(context));
    } on HttpExpection catch (e) {
      _sendErrorToFirebase(e, transactionCreated);
      _showFailureDialog(context, message: e.message);
    } on TimeoutException catch (e) {
      _sendErrorToFirebase(e, transactionCreated);
      _showFailureDialog(context,
          message: 'Timeout during transaction process.');
    } on Exception catch (e) {
      _sendErrorToFirebase(e, transactionCreated);
      _showFailureDialog(context);
    }
  }

  void _sendErrorToFirebase(Exception e, Transaction transactionCreated) {
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
      FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
      FirebaseCrashlytics.instance
          .setCustomKey('transactionId', transactionCreated.id);
      FirebaseCrashlytics.instance.recordError(e, null);
    }
  }

  void _showFailureDialog(
    BuildContext context, {
    String? message = 'Unknown error.',
  }) {
    final snackBar = SnackBar(content: Text(message!));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
