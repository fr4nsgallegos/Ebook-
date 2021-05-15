import 'dart:convert';

import 'package:flutter_ebook_app/models/pregunta.dart';
import 'package:flutter_ebook_app/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class HttpHelper {
  String urlBase = 'http://10.0.2.2:3000/api/';
  String urlContrasena = "http://10.0.2.2:3001/api/";

  Future<String> addFavorito(String url, String idUsuario) async {
    final response = await http.post(urlBase + "favoritos/", body: {
      "id_usuario": idUsuario,
      "libro": url,
    });

    if (response.statusCode != 200 && response.statusCode != 201) {
      print("Algo salio mal");
      print(response.body);
      return null;
    }
    // print(jsonDecode(response.body)["id"]);
    // return jsonDecode(response.body)["id"].toString();
  }

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

  Future<String> crearPregunta(
    String correo,
    String pregunta,
    String respuesta,
    String codigo,
    String contrasena,
  ) async {
    final response = await http.post(urlContrasena + "usuarios/", body: {
      "correo": correo,
      "pregunta": pregunta,
      "respuesta": respuesta,
      "codigo": codigo,
      "contrasena": contrasena,
    });
    print(response.body);
    if (response.statusCode == 201) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("Exito de preguntaaaaaaaa");
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

  Future<List<Pregunta>> getPregunta(String correo) async {
    final response = await http.get(
      (urlContrasena + "usuarios/" + correo + "/"),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
      List<Pregunta> preguntas =
          responseJson.map((m) => new Pregunta.fromJson(m)).toList();
      print("se cargaron las preguntas");
      print(correo);
      return preguntas;
      //var responseJson = json.decode(utf8.decode(response.bodyBytes));
      //return Empresa.fromJson(responseJson);
    } else {
      print("${response.statusCode} ----> ${response.body}");
      return null;
    }
  }

  Future<String> patchContrasena(String correo, String contrasena) async {
    final response =
        await http.patch(urlContrasena + "usuarios/" + correo, body: {
      "contrasena": contrasena,
    });
    print(response.body);
    if (response.statusCode == 201) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("Exito de passworddd");
    }
  }

  Future<String> patchContrasena1(String uid, String contrasena) async {
    final response = await http.patch(urlBase + "usuario/" + uid, body: {
      "contrasena": contrasena,
    });
    print(response.body);
    if (response.statusCode == 201) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("Exito de passworddd");
    }
  }

  Future<String> patchUsuario(
      String uid, String nombre, String descripcion) async {
    final response = await http.patch(urlBase + "usuario/" + uid, body: {
      "nombre": nombre,
      "descripcion": descripcion,
    });
    print(response.body);
    if (response.statusCode == 201) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("Exito de passworddd");
    }
  }

  Future<String> patchPreguntaCorreo(String uid, String correo) async {
    final response = await http.patch(urlContrasena + "usuarios/" + uid, body: {
      "correo": correo,
    });
    print(response.body);
    if (response.statusCode == 201) {
      final responseJson = json.decode(utf8.decode(response.bodyBytes));
      print("Exito de passworddd");
    }
  }

  Future<String> actualizarUsuario(PickedFile imagen) async {
    final url = Uri.parse(urlBase + "usuario/");

    final imageUploadRequest = http.MultipartRequest('POST', url);

    if (imagen != null) {
      final mimeType = mime(imagen.path).split('/');
      final file = await http.MultipartFile.fromPath('imagen', imagen.path,
          contentType: MediaType(mimeType[0], mimeType[1]));
      imageUploadRequest.files.add(file);
    }

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print(resp.body);
      print("Algo salio mal");
      return null;
    }

    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
    print(resp.body);
    return resp.body;
  }
}
