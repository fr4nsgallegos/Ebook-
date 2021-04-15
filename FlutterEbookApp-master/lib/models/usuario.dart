class Usuario {
  Usuario({
    this.codigo,
    this.nombre,
    this.correo,
    this.contrasena,
    this.descripcion,
  });

  String codigo;
  String nombre;
  String correo;
  String contrasena;
  String descripcion;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        codigo: json["codigo"],
        nombre: json["nombre"],
        correo: json["correo"],
        contrasena: json["contrasena"],
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "nombre": nombre,
        "correo": correo,
        "contrasena": contrasena,
        "descripcion": descripcion,
      };
}
