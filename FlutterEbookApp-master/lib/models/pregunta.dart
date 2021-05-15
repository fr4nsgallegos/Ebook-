// To parse this JSON data, do
//
//     final pregunta = preguntaFromJson(jsonString);

import 'dart:convert';

List<Pregunta> preguntaFromJson(String str) =>
    List<Pregunta>.from(json.decode(str).map((x) => Pregunta.fromJson(x)));

String preguntaToJson(List<Pregunta> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pregunta {
  Pregunta({
    this.correo,
    this.pregunta,
    this.respuesta,
    this.codigo,
    this.contrasena,
  });

  String correo;
  String pregunta;
  String respuesta;
  String codigo;
  String contrasena;

  factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
        correo: json["correo"],
        pregunta: json["pregunta"],
        respuesta: json["respuesta"],
        codigo: json["codigo"],
        contrasena: json["contrasena"],
      );

  Map<String, dynamic> toJson() => {
        "correo": correo,
        "pregunta": pregunta,
        "respuesta": respuesta,
        "codigo": codigo,
        "contrasena": contrasena,
      };
}
