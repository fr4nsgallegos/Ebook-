import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ebook_app/api/http_helper.dart';
import 'package:flutter_ebook_app/models/pregunta.dart';
import 'package:flutter_ebook_app/util/consts.dart';
import 'package:flutter_ebook_app/views/screens/login_screen.dart';
import 'package:logger/logger.dart';

class ValidarPassword extends StatefulWidget {
  Pregunta pregunta;
  ValidarPassword({Key key, this.pregunta}) : super(key: key);

  @override
  _ValidarPasswordState createState() => _ValidarPasswordState();
}

class _ValidarPasswordState extends State<ValidarPassword> {
  TextEditingController txtPassword = TextEditingController();

  Logger logger = Logger();
  Future<String> logIn(String email, String password) async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      print(credential.user.uid);

      return credential.user.uid;
    } on FirebaseAuthException catch (e) {
      print("--------------------");
      logger.e(e.message);
    }
  }

  Future<String> cambiarContrasena(String contrasenaNueva) {
    logIn(widget.pregunta.correo, widget.pregunta.contrasena).then((value) {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      var user = firebaseAuth.currentUser;

      user.updatePassword(contrasenaNueva).then((value) {
        HttpHelper().patchContrasena(widget.pregunta.correo, txtPassword.text);
        HttpHelper().patchContrasena1(widget.pregunta.codigo, txtPassword.text);

        logger.d("contraseña actualizada");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ));
      });
    });
  }

  Widget _buildContrasena() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Ingresa tu nueva contraseña',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: txtPassword,
            keyboardType: TextInputType.emailAddress,
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
              hintText: 'Ingresa tu nueva contrasena',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          //print(widget.pregunta.correo);

          cambiarContrasena(txtPassword.text);
          // String uid = await signUpPhone(txtCorreo.text);
          // if (uid != null && uid.isNotEmpty) {
          //   Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => HomeScreen(),
          //       ));
          // }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Enviar',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
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
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Logo(),
                      SizedBox(
                        height: 100,
                      ),
                      Text(
                        'Recuperar contraseña',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      _buildContrasena(),
                      SizedBox(height: 15),
                      _buildLoginBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
