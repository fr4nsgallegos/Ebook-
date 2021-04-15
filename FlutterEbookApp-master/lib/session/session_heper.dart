import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  String codigo = '';
  String correo;
  String nombres;
  String descripcion;

  Future fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    codigo = prefs.getString("codigo");
    correo = prefs.getString("correo");
    nombres = prefs.getString("nombre");
    descripcion = prefs.getString("descripcion");
  }

  Future clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    codigo = '';
    prefs.setString("codigo", codigo);
  }
}
