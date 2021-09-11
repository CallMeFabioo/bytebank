import 'package:flutter/material.dart';
import 'package:bytebank/database/dao/contact.dart';
import 'package:bytebank/models/contact.dart';

class ContactForm extends StatefulWidget {
  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _fullNameInput = TextEditingController();
  final TextEditingController _accountNumberInput = TextEditingController();
  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _fullNameInput,
              decoration: InputDecoration(
                labelText: 'Full name',
              ),
              style: TextStyle(fontSize: 24.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _accountNumberInput,
                decoration: InputDecoration(
                  labelText: 'Account number',
                ),
                style: TextStyle(fontSize: 24.0),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  child: Text('Create'),
                  onPressed: () {
                    final String fullName = _fullNameInput.text;
                    final int? accountNumber =
                        int.tryParse(_accountNumberInput.text);

                    final Contact newContact =
                        Contact(0, fullName, accountNumber);

                    _dao.save(newContact).then(
                          (id) => Navigator.pop(context, newContact.toString()),
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
