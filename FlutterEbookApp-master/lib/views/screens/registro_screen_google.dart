import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ebook_app/provider/user_provider.dart';
import 'package:flutter_ebook_app/util/consts.dart';
import 'package:flutter_ebook_app/api/http_helper.dart';
import 'package:flutter_ebook_app/views/screens/login_screen.dart';
import 'package:flutter_ebook_app/widgets/widget_popup.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegistroScreenGoogle extends StatefulWidget {
  String correo;
  String nombre;
  RegistroScreenGoogle({Key key, this.correo, this.nombre}) : super(key: key);

  @override
  _RegistroScreenGoogleState createState() => _RegistroScreenGoogleState();
}

class _RegistroScreenGoogleState extends State<RegistroScreenGoogle> {
  final nombreController = TextEditingController();
  final contrasenaController = TextEditingController();
  final correoController = TextEditingController();
  final descripcionController = TextEditingController();
  final txtPregunta = TextEditingController();
  final txtRespuesta = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  @override
  void initState() {
    super.initState();
    correoController.text = widget.correo;
    nombreController.text = widget.nombre;
  }

  PickedFile _imageFile1;
  GlobalKey<FormState> _key = new GlobalKey();

  /*
  // ignore: non_constant_identifier_names
  Future<bool> registrar_empleador() async {
    var url = 'http://192.168.2.101:8085/empleador';
    var body = jsonEncode({
      'nombre': nombreController.text.toString(),
      'apellido': apellidoController.text.toString(),
      'contrasena': contrasenaController.text.toString(),
      'correo': correoController.text.toString(),
      'dni': dniController.text.toString()
    });
    var response = await http.post(url, body: body);
    final resp = json.decode(response.body);

    if (resp['success'] != null || resp['success'] != 'is not true') {
      final token = resp['code'];
      print('successs');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (token == "correcto") {
        Fluttertoast.showToast(
          msg: "Guardando",
          toastLength: Toast.LENGTH_LONG,
        );
        return true;
      } else {
        Fluttertoast.showToast(
          msg: resp['message'],
          toastLength: Toast.LENGTH_LONG,
        );
        return false;
      }
    }
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return false;
  }*/
  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  String _validarNome(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o nome";
    } else if (!regExp.hasMatch(value)) {
      return "O nome deve conter caracteres de a-z ou A-Z";
    }
    return null;
  }

  String _validarCelular(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Informe o celular";
    } else if (value.length != 10) {
      return "O celular deve ter 10 dígitos";
    } else if (!regExp.hasMatch(value)) {
      return "O número do celular so deve conter dígitos";
    }
    return null;
  }

  String _validarEmail(String value) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);
    if (value.length == 0) {
      return "Email";
    } else if (!regExp.hasMatch(value)) {
      return "Email inválido";
    } else {
      return null;
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Correo electrónico',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 18, left: 8, bottom: 8, right: 5),
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              maxLength: 40,
              validator: (valor) {
                if (valor.isEmpty) {
                  return "Este campo esta vacio";
                } else if (!isEmail(valor)) {
                  return "Correo no valido";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              controller: correoController,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                hintText: 'Ingresa tu correo',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _buildPregunta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Ingresa tu pregunta secreta',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: txtPregunta,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.security,
                color: Colors.white,
              ),
              hintText: 'Ingresa tu pregunta secreta',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _buildRespuesta() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Ingresa tu respuesta secreta',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: txtRespuesta,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.question_answer,
                color: Colors.white,
              ),
              hintText: 'Ingresa tu respuesta secreta',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Contraseña',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 18, left: 8, bottom: 8, right: 5),
            child: TextFormField(
              maxLength: 30,
              validator: (String valor) {
                if (valor.isEmpty) {
                  return "Este campo esta vacio";
                } else if (valor.length < 8) {
                  return "La contraseña es muy corta";
                }
                return null;
              },
              obscureText: true,
              controller: contrasenaController,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                hintText: 'Ingresar tu contraseña',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _buildNombres() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nombres y Apellidos',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 18, left: 8, bottom: 8, right: 5),
            child: TextFormField(
              maxLength: 40,
              textAlignVertical: TextAlignVertical.top,
              validator: (String valor) {
                if (valor.isEmpty) {
                  return "Este campo esta vacio";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
              controller: nombreController,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.people,
                  color: Colors.white,
                ),
                hintText: 'Ingresa tus nombres y apellidos',
                hintStyle: kHintTextStyle,
                alignLabelWithHint: true,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _buildAcercaMi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Acerca de ti',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 210.0,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 8, bottom: 8, right: 5),
            child: TextFormField(
              validator: (valor) {
                if (valor.isEmpty) {
                  return "Este campo esta vacio";
                } else if (valor.length < 5) {
                  return "Descripción muy corta";
                }
                return null;
              },
              maxLength: 400,
              textAlignVertical: TextAlignVertical.top,
              maxLines: 8,
              keyboardType: TextInputType.emailAddress,
              controller: descripcionController,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.person_search_rounded,
                  color: Colors.white,
                ),
                hintText: 'Ingresa una descripción acerca de ti',
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Future<String> signUp(String correo, String contrasena) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    UserCredential credential = await firebaseAuth
        .createUserWithEmailAndPassword(email: correo, password: contrasena);
    return credential.user.uid;
  }

  Widget _buildRegistroBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_claveFormulario.currentState.validate()) {
            String uid =
                await signUp(correoController.text, contrasenaController.text);
            if (uid.isNotEmpty) {
              print(uid);

              HttpHelper()
                  .crearUsuario(
                uid,
                correoController.text,
                contrasenaController.text,
                nombreController.text,
                descripcionController.text,
              )
                  .then((value) {
                HttpHelper().actualizarUsuario(_imageFile1).then((value) {
                  print("subiendoimagen");
                });
                HttpHelper()
                    .crearPregunta(correoController.text, txtPregunta.text,
                        txtRespuesta.text, uid, contrasenaController.text)
                    .then((value) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                  snackBar3Sec(context, "Usuario creado con éxito");
                });

                print(uid);
              });

              print("usuario creado");
            }
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Registrar',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildFoto(BuildContext context) {
    var imagen;
    return GestureDetector(
      onTap: () async {
        await _displayPickImageDialog(context, (ImageSource source) async {
          try {
            _imageFile1 =
                await _picker.getImage(source: source, imageQuality: 50);
            setState(() {
              _imageFile1 = _imageFile1;
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
        });
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: _imageFile1 != null && _imageFile1.path.length > 0
                ? FileImage(
                    File(_imageFile1.path),
                  )
                : AssetImage("assets/images/app-icon.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  final _claveFormulario = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF012F3D),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF012F3D),
                  Color(0xFF012F3D),
                  Color(0xFF0A4F64),
                  Color(0xFF0A4F64),
                ],
                stops: [0.1, 0.4, 0.6, 0.9],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildFoto(context),
              Text(
                "Sube una foto",
                style: TextStyle(color: Colors.white),
              ),
              // Logo(),
              SizedBox(
                height: 35,
              ),
              Text(
                'Regístrate',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.0),
              Form(
                key: _claveFormulario,
                child: Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                    ),
                    shrinkWrap: true,
                    children: [
                      _buildEmailTF(),
                      _buildPasswordTF(),
                      _buildNombres(),
                      _buildPregunta(),
                      _buildRespuesta(),
                      _buildAcercaMi(),
                      _buildRegistroBtn(),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Selecciona una imagen desde:'),
            actions: <Widget>[
              FlatButton(
                child: const Text('CANCELAR'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('GALERÍA'),
                onPressed: () {
                  onPick(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: const Text('CÁMARA'),
                  onPressed: () {
                    onPick(ImageSource.camera);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Center buildBotonesImagenes(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          FlatButton(
            onPressed: () async {
              _onImageButtonPressed(context: context, imageFile: 1);
            },
            child: _imageFile1 != null && _imageFile1.path.length > 0
                ? Stack(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        File(_imageFile1.path),
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: SizedBox(
                        child: IconButton(
                          icon: Icon(
                            Icons.cancel,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              _imageFile1 = null;
                            });
                          },
                        ),
                      ),
                    )
                  ])
                : Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }

  void _onImageButtonPressed({BuildContext context, int imageFile}) async {
    await _displayPickImageDialog(context, (ImageSource source) async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
        );
        print(pickedFile.path);
        setState(() {
          if (imageFile == 1) {
            _imageFile1 = pickedFile;
          }
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('assets/images/app-icon.png');
    Image image = Image(image: assetImage);
    return Container(
      child: image,
      height: 100,
    );
  }
}

typedef void OnPickImageCallback(ImageSource source);
