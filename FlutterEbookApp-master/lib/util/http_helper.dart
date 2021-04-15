import 'dart:convert';

import 'package:flutter_ebook_app/models/usuario.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  String urlBase = 'http://10.0.2.2:3000/api/';

  Future<String> crearUsuario(
    String codigo,
    String correo,
    String contrasena,
    String nombres,
    String descripcion,
  ) async {
    final response = await http.post(urlBase + "usuario/", body: {
      "codigo": codigo,
      "correo": correo,
      "contrasena": contrasena,
      "nombre": nombres,
      "descripcion": descripcion,
    });
    print(response.body);
    if (response.statusCode == 201) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("Exito");
    }
  }

  Future<Usuario> getUsuario(String id) async {
    final response = await http.get(
      (urlBase + "usuario/" + id + "/"),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return Usuario.fromJson((jsonDecode(utf8.decode(response.bodyBytes))));
      //var responseJson = json.decode(utf8.decode(response.bodyBytes));
      //return Empresa.fromJson(responseJson);
    } else {
      print("${response.statusCode} ----> ${response.body}");
      return null;
    }
  }
}
