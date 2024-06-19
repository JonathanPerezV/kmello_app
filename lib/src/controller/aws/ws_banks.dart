import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kmello_app/src/controller/preferences/user_preferences.dart';
import 'package:kmello_app/src/models/account_model.dart';
import 'package:kmello_app/src/models/bank_model.dart';

class WSBanks {
  final String _url = dotenv.env["ws_banks_dev"]!;

  Future<List<BankModel>?> getAllBanks() async {
    try {
      final response = await http.post(Uri.parse(_url),
          body: jsonEncode({"operacion": "get-banks"}));

      if (response.statusCode > 199 && response.statusCode < 300) {
        final decode = jsonDecode(response.body);

        if (decode.length > 0) {
          List<BankModel> bancos = [];

          for (var bank in decode) {
            bancos.add(BankModel.fromJson(bank));
          }

          return bancos;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("err: $e");

      rethrow;
    }
  }

  Future<int> insertUserBankAccount(AccountModel account) async {
    try {
      final response = await http.post(Uri.parse(_url),
          body: jsonEncode(
              {"operacion": "insert-account", "info": account.toJson()}));

      if (response.statusCode > 199 && response.statusCode < 300) {
        final decode = jsonDecode(response.body);
        return decode["id"];
      } else {
        final decode = jsonDecode(response.body);
        return decode["id"];
      }
    } catch (e) {
      debugPrint("err: $e");
      rethrow;
    }
  }

  Future<String> updateUserBankAccount(
      AccountModel account, int idCuenta) async {
    try {
      final response = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "update-account",
            "info": account.toJson()..addAll({"id_cuenta": idCuenta})
          }));
      if (response.statusCode > 199 && response.statusCode < 300) {
        final decode = jsonDecode(response.body);
        return decode["status"];
      } else {
        final decode = jsonDecode(response.body);
        return decode["status"];
      }
    } catch (e) {
      debugPrint("err: $e");
      rethrow;
    }
  }

  Future<AccountModel?> getAccountUserBank() async {
    try {
      final pfrc = UserPreferences();

      final id = await pfrc.getIdPerson();

      final response = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "operacion": "get-account",
            "info": {"id_usuario": id}
          }));

      if (response.statusCode > 199 && response.statusCode < 300) {
        final decode = jsonDecode(response.body);

        return AccountModel.fromJson(decode[0]);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("err: $e");
      rethrow;
    }
  }
}
