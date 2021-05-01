import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/provider/user_provider.dart';
import 'package:flutter_ebook_app/session/session_heper.dart';
import 'package:flutter_ebook_app/api/http_helper.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class PerfilScreen extends StatefulWidget {
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool editPwd = false;
  // HttpHelper helper = HttpHelper();

  // PickedFile _imageFile1;
  // dynamic _pickImageError;
  // final ImagePicker _picker = ImagePicker();

  TextEditingController txtNombre = new TextEditingController();
  TextEditingController txtDescripcion = new TextEditingController();
  TextEditingController txtCorreo = new TextEditingController();
  TextEditingController txtPassword = new TextEditingController();
  final logger = Logger();

  final kBoxDecorationStyle = BoxDecoration(
    //color: Color(0xFF2A98CC),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: Color(0xFF2A98CC),
      width: 2,
    ),
    /*boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],*/
  );

  // Widget _buildFoto(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () async {
  //       await _displayPickImageDialog(context, (ImageSource source) async {
  //         try {
  //           _imageFile1 =
  //               await _picker.getImage(source: source, imageQuality: 50);
  //           setState(() {
  //             _imageFile1 = _imageFile1;
  //           });
  //         } catch (e) {
  //           setState(() {
  //             _pickImageError = e;
  //           });
  //         }
  //       });
  //     },
  //     child: Container(
  //       width: 150,
  //       height: 150,
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         image: DecorationImage(
  //           image: _imageFile1 != null && _imageFile1.path.length > 0
  //               ? FileImage(
  //                   File(_imageFile1.path),
  //                 )
  //               : Provider.of<UserProvider>(context).usuario.imagen != ""
  //                   ? NetworkImage(
  //                       Provider.of<UserProvider>(context).usuario.imagen)
  //                   : AssetImage("assets/images/splash.png"),
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBox(
      String nombre, Icon icono, TextEditingController controlador) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          nombre,
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextField(
            controller: controlador,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14, right: 10),
              prefixIcon: icono,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    txtNombre.text = Provider.of<UserProvider>(context).usuario.nombre;
    // txtNombre.text = SessionHelper().nombres;

    txtCorreo.text = Provider.of<UserProvider>(context).usuario.correo;
    txtDescripcion.text =
        Provider.of<UserProvider>(context).usuario.descripcion;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '',
        ),
      ),
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // _buildFoto(context),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Mis Datos',
                  style: TextStyle(
                    color: Color(0xFF2A98CC),
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _buildBox("Nombres y apellidos:",
                    Icon(Icons.people, color: Color(0xFF2A98CC)), txtNombre),

                _buildBox(
                    "Correo electrónico:",
                    Icon(Icons.alternate_email, color: Color(0xFF2A98CC)),
                    txtCorreo),
                _buildBox(
                    "Acerca de mi:",
                    Icon(Icons.people, color: Color(0xFF2A98CC)),
                    txtDescripcion),

                _buildBox(
                  "Actualizar contraseña",
                  Icon(
                    Icons.lock_sharp,
                    color: Color(0xFF2A98CC),
                  ),
                  txtPassword,
                ),

                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  onPressed: () async {
                    // Usuario usr =
                    //     Provider.of<UserProvider>(context, listen: false)
                    //         .usuario;

                    // usr.firstName = txtNombre.text;
                    // usr.lastName = txtApellido.text;
                    // usr.email = txtCorreo.text;
                    // usr.password = txtPassword.text;
                    // await helper
                    //     .actualizarUsuario(usr, _imageFile1)
                    //     .then((value) {
                    //   snackBarCambiosGuardados(context);
                    // });
                    // getUserData(usr.jwtToken, context);
                  },
                  child: Text(
                    "Guardar cambios",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.3,
                    ),
                  ),
                  color: Color(0xFF2A98CC),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Color(0xFF2A98CC)),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget snackBarCambiosGuardados(BuildContext context) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      message: "Cambios guardados",
      duration: Duration(seconds: 5),
    )..show(context);
  }

  // Future<void> _displayPickImageDialog(
  //     BuildContext context, OnPickImageCallback onPick) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Selecciona una imagen desde:'),
  //           actions: <Widget>[
  //             FlatButton(
  //               child: const Text('CANCELAR'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             FlatButton(
  //               child: const Text('GALERÍA'),
  //               onPressed: () {
  //                 onPick(ImageSource.gallery);
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             FlatButton(
  //                 child: const Text('CÁMARA'),
  //                 onPressed: () {
  //                   onPick(ImageSource.camera);
  //                   Navigator.of(context).pop();
  //                 }),
  //           ],
  //         );
  //       });
  // }

  // Center buildBotonesImagenes(BuildContext context) {
  //   return Center(
  //     child: ListView(
  //       shrinkWrap: true,
  //       scrollDirection: Axis.horizontal,
  //       children: [
  //         FlatButton(
  //           onPressed: () async {
  //             _onImageButtonPressed(context: context, imageFile: 1);
  //           },
  //           child: _imageFile1 != null && _imageFile1.path.length > 0
  //               ? Stack(children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: Image.file(
  //                       File(_imageFile1.path),
  //                       width: 100,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                   Positioned(
  //                     right: 0,
  //                     child: SizedBox(
  //                       child: IconButton(
  //                         icon: Icon(
  //                           Icons.cancel,
  //                         ),
  //                         color: Colors.red,
  //                         onPressed: () {
  //                           setState(() {
  //                             _imageFile1 = null;
  //                           });
  //                         },
  //                       ),
  //                     ),
  //                   )
  //                 ])
  //               : Icon(Icons.camera_alt),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _onImageButtonPressed({BuildContext context, int imageFile}) async {
  //   await _displayPickImageDialog(context, (ImageSource source) async {
  //     try {
  //       final pickedFile = await _picker.getImage(
  //         source: source,
  //       );
  //       print(pickedFile.path);
  //       setState(() {
  //         if (imageFile == 1) {
  //           _imageFile1 = pickedFile;
  //         }
  //       });
  //     } catch (e) {
  //       setState(() {
  //         _pickImageError = e;
  //       });
  //     }
  //   });
  // }
}

// typedef void OnPickImageCallback(ImageSource source);
