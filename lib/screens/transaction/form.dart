import 'package:flutter/material.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/components/Input.dart';

const _titleAppBar = 'Criando transferência';

const _accountInputLabelText = 'Número da conta';
const _accountInputHintText = '0000';

const _valueInputLabelText = 'Valor';
const _valueInputHintText = '0.00';

const _buttonText = 'Confirmar';

class TransactionForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TransactionFormState();
  }
}

class TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueInput = TextEditingController();
  final TextEditingController _accountInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleAppBar),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Input(
              controller: _valueInput,
              labelText: _accountInputLabelText,
              hintText: _accountInputHintText,
            ),
            Input(
              controller: _accountInput,
              labelText: _valueInputLabelText,
              hintText: _valueInputHintText,
              icon: Icons.monetization_on,
            ),
            ElevatedButton(
              onPressed: () => createTransaction(context),
              child: Text(_buttonText),
            )
          ],
        ),
      ),
    );
  }

  void createTransaction(BuildContext context) {
    final int? account = int.tryParse(_accountInput.text);
    final double? value = double.tryParse(_valueInput.text);

    if (account != null && value != null) {
      Navigator.pop(context, Transaction(value, account));
    }
  }
}
