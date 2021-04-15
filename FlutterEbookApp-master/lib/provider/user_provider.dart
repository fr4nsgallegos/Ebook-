import 'package:flutter/cupertino.dart';
import 'package:flutter_ebook_app/models/usuario.dart';
import 'package:flutter_ebook_app/session/session_heper.dart';

class UserProvider extends ChangeNotifier {
  Usuario usuario;

  Future fetchUserData() async {
    SessionHelper session = SessionHelper();
    await session.fetchUserData();
    usuario = Usuario(
      codigo: session.codigo,
      correo: session.correo,
      descripcion: session.descripcion,
      nombre: session.nombres,
    );
  }

  Future clearUserData() async {
    SessionHelper session = SessionHelper();
    await session.clearUserData();
    usuario = null;
    notifyListeners();
  }
}
