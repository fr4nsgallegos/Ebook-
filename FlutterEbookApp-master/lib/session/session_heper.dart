import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  String codigo = '';
  String correo;
  String nombres;
  String descripcion;
  String contrasena;
  String imagen;
  String tituloCategoria;
  String codCategoria;
  String codLogin;

  static final SessionHelper _sessionHelper = SessionHelper._internal();

  SessionHelper._internal();

  factory SessionHelper() {
    return _sessionHelper;
  }
  Future fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    codigo = prefs.getString("codigo");
    correo = prefs.getString("correo");
    nombres = prefs.getString("nombre");
    descripcion = prefs.getString("descripcion");
    contrasena = prefs.getString("contrasena");
    imagen = prefs.getString(("imagen"));
  }

  Future clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    codigo = '';
    prefs.setString("codigo", codigo);
  }
}
