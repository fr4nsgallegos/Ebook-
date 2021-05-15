import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ebook_app/api/http_helper.dart';
import 'package:flutter_ebook_app/models/pregunta.dart';
import 'package:flutter_ebook_app/util/consts.dart';
import 'package:flutter_ebook_app/views/screens/validar_password.dart';
import 'package:flutter_ebook_app/widgets/widget_popup.dart';

class PasswordScreen1 extends StatefulWidget {
  PasswordScreen1({Key key}) : super(key: key);

  @override
  _PasswordScreen1State createState() => _PasswordScreen1State();
}

class _PasswordScreen1State extends State<PasswordScreen1> {
  TextEditingController txtCorreo = TextEditingController();
  TextEditingController txtPregunta = TextEditingController();
  TextEditingController txtRespuesta = TextEditingController();

  Widget _buildCorreo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Ingresa tu correo electrónico',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: txtCorreo,
            keyboardType: TextInputType.emailAddress,
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
              hintText: 'Ingresa Correo electrónico',
              hintStyle: kHintTextStyle,
            ),
          ),
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
      ],
    );
  }

  List<Pregunta> preguntas;
  Pregunta pregunta;
  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          preguntas =
              await HttpHelper().getPregunta(txtCorreo.text).then((value) {
            pregunta = value[0];
            if (pregunta.pregunta == txtPregunta.text &&
                pregunta.respuesta == txtRespuesta.text) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ValidarPassword(
                      pregunta: pregunta,
                    ),
                  ));
            } else {
              snackBar3Sec(context, "Lo sentimos no coincide");
            }
          });

          print(pregunta.pregunta);
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
                      _buildCorreo(),
                      SizedBox(height: 15.0),
                      _buildPregunta(),
                      SizedBox(height: 15),
                      _buildRespuesta(),
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
