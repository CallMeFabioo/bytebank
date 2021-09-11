import 'package:sqflite/sqlite_api.dart';
import 'package:bytebank/database/app.dart';
import 'package:bytebank/models/contact.dart';

class ContactDao {
  static const String tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _account_number = 'account_number';
  static const String tableSql =
      'CREATE TABLE $tableName($_id INTEGER PRIMARY KEY, $_name, $_account_number INTEGER)';

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();

    Map<String, dynamic> contactMap = _toMap(contact);

    return db.insert(tableName, contactMap);
  }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> results = await db.query(tableName);

    List<Contact> contacts = _toList(results);

    return contacts;
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();

    contactMap[_name] = contact.fullName;
    contactMap[_account_number] = contact.accountNumber;

    return contactMap;
  }

  List<Contact> _toList(List<Map<String, dynamic>> results) {
    final List<Contact> contacts = [];

    for (Map<String, dynamic> row in results) {
      final Contact contact = Contact(
        row[_id],
        row[_name],
        row[_account_number],
      );

      contacts.add(contact);
    }
    return contacts;
  }
}
