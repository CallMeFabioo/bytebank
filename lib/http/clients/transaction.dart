import 'dart:convert';
import 'package:http/http.dart';
import 'package:bytebank/http/api.dart';
import 'package:bytebank/models/transaction.dart';

final Uri apiUrl = Uri(
  scheme: 'http',
  host: '192.168.122.1',
  port: 8080,
  path: '/transactions',
);

class TransactionApiClient {
  Future<List<Transaction>> getAllTransactions() async {
    final Response response = await client.get(apiUrl);

    final List<dynamic> responseJson = jsonDecode(response.body);

    return responseJson
        .map((dynamic item) => Transaction.fromJson(item))
        .toList();
  }

  Future<Transaction> saveTransaction(
    Transaction transaction,
    String password,
  ) async {
    await Future.delayed(Duration(seconds: 2));

    final Response response = await client.post(
      apiUrl,
      body: jsonEncode(transaction.toJson()),
      headers: {
        'Content-type': 'application/json',
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }

    throw HttpExpection(message: _getStatusCodeMessage(response.statusCode));
  }

  static final Map<int, String> _statusCodeResponses = {
    400: 'There was an error submiting the transaction.',
    401: 'Authentication failed.',
    409: 'Transaction already exists.'
  };

  String? _getStatusCodeMessage(int statusCode) {
    if (_statusCodeResponses.containsKey(statusCode)) {
      return _statusCodeResponses[statusCode];
    }

    return 'Unknown error.';
  }
}

class HttpExpection implements Exception {
  final String? message;

  HttpExpection({this.message = 'Unknown error.'});
}
