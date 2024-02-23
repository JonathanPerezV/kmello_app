import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class WSSms {
  final String _url = dotenv.env["claro_sms"]!;

  Future<String> enviarMensaje(String number, String code) async {
    String status = "";

    try {
      final request = await http.post(Uri.parse(_url),
          headers: {"Authorization": dotenv.env["token_sms"]!},
          body: jsonEncode({
            "phoneNumber": number,
            "messageId": "136546",
            "transactionId": "${number}001",
            "dataVariable": ["23", code]
          }));

      if (request.statusCode > 199 && request.statusCode < 300) {
        final decode = jsonDecode(request.body);
        final desError = decode["desError"];

        status = desError.toString();
      } else {
        status = "No se pudo enviar el mensaje, inténtelo más tarde";
      }
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    }

    return status;
  }
}
