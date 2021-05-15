// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

List<Usuario> usuarioFromJson(String str) =>
    List<Usuario>.from(json.decode(str).map((x) => Usuario.fromJson(x)));

String usuarioToJson(List<Usuario> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Usuario {
  Usuario({
    this.codigo,
    this.nombre,
    this.correo,
    this.contrasena,
    this.descripcion,
    this.imagen,
  });

  String codigo;
  String nombre;
  String correo;
  String contrasena;
  String descripcion;
  String imagen;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        codigo: json["codigo"],
        nombre: json["nombre"],
        correo: json["correo"],
        contrasena: json["contrasena"],
        descripcion: json["descripcion"],
        imagen: json["imagen"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "nombre": nombre,
        "correo": correo,
        "contrasena": contrasena,
        "descripcion": descripcion,
        "imagen": imagen,
      };
}
