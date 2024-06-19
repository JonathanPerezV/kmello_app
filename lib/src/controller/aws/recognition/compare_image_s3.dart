import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kmello_app/src/controller/preferences/user_preferences.dart';

class AmazonRecognitionUpload {
  final String _url = dotenv.env["ws_recognition"]!;

  final usrpfrc = UserPreferences();

  Future<String> amazonRecognition(File userFace, {String? cedula}) async {
    String result = "error";

    String identification = cedula ?? await usrpfrc.getUserIdentification();

    final fileBytes = userFace.readAsBytesSync();

    final fileBase64 = base64Encode(fileBytes);

    try {
      final request = await http.post(Uri.parse(_url),
          body: jsonEncode({
            "obj1": fileBase64,
            "obj2": identification,
            "bucket": "kmello-dev"
          }));

      if (request.statusCode > 199 && request.statusCode < 300) {
        final decode = jsonDecode(request.body);

        final similarity = double.parse(decode);

        final rounded = similarity.round();

        if (rounded >= 90) {
          result = "ok";
        } else if (rounded > 80) {
          result = "repeat";
        }

        debugPrint("similitud: $rounded");
      }
    } catch (e) {
      final map = e;
      debugPrint("$map");
      return result;
    }

    return result;
  }
}
