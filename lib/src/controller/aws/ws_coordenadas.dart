import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kmello_app/src/models/coordenadas_model.dart';

class WsCoordenadas {
  final String _url = dotenv.env["ws_coordenadas_prod"]!;

  Future<int> insertarCoordenada(CoordenadasModel coor) async {
    int res = 0;
    try {
      final data = await http.post(Uri.parse(_url),
          body: jsonEncode({"operacion": "insert", "info": coor.toJson()}));

      final decode = jsonDecode(data.body);
      if (data.statusCode == 200) {
        res = decode["datos"]["id"];
      }
    } catch (e) {
      debugPrint("error $e");
      rethrow;
    }
    return res;
  }
}
