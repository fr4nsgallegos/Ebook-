import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ebook_app/api/ebook_api.dart';
import 'package:flutter_ebook_app/models/usuario.dart';
import 'package:flutter_ebook_app/provider/user_provider.dart';
import 'package:flutter_ebook_app/api/http_helper.dart';
import 'package:flutter_ebook_app/views/screens/password_screen1.dart';
import 'package:flutter_ebook_app/theme/theme_config.dart';
import 'package:flutter_ebook_app/views/screens/registro_screen.dart';
import 'package:flutter_ebook_app/views/screens/registro_screen_google.dart';
import 'package:flutter_ebook_app/views/splash/splash.dart';
import 'package:flutter_ebook_app/widgets/widget_popup.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

Future getDataUser(String id, BuildContext context) {
  final dio = Dio();
  logger.d("User data recoverded " + id);
  // GetIt.I.unregister();
  // GetIt.I.registerSingleton(RestClient(dio));
  GetIt.I<RestClient>().getUsuario(id).then((value) async {
    logger.d("recupernado sata de usuario ");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("codigo", value[0].codigo);
    prefs.setString("nombre", value[0].nombre);
    prefs.setString("descripcion", value[0].descripcion);
    prefs.setString("correo", value[0].correo);
    prefs.setString("imagen", value[0].imagen);
    Provider.of<UserProvider>(context, listen: false).fetchUserData();
  }).catchError((Object obj) {
    switch (obj.runtimeType) {
      case DioError:
        final res = (obj as DioError).response;
        logger.e("Got error : ${res.statusCode} -> ${res.statusMessage}");
        break;
      default:
        logger.e("Got error :" + obj.toString());
    }
  });
}

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
  final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken);

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User user = authResult.user;

  if (user != null) {
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
    print(user.email);
    print(user.displayName);
    logger.d('signInWithGoogle succeeded: $user');
    BuildContext context;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RegistroScreenGoogle(
                  correo: user.email,
                  nombre: user.displayName,
                )));
  }
}

// Future _getUserData(BuildContext context, String id) async {
//   var response = await http.get(Constantes.url + "usuario/" + id).then((value)async{

//   print("${value.body}");

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString("codigo", );
//     prefs.setString("nombre", r["nombres"]);
//     prefs.setString("descripcion", r["descripcion"]);
//     prefs.setString("correo", r["correo"]);
//     Provider.of<UserProvider>(context, listen: false).fetchUserData();

//   });
//  else {
//     print(response.body);
//     // snackBar3Sec(context, "Usuario o contraseña inválido");
//   }
// }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Trace myTrace = FirebasePerformance.instance.newTrace("prueba");
  bool _rememberMe = false;
  TextEditingController txtCorreo = TextEditingController();
  TextEditingController txtPwd = TextEditingController();
  Usuario _usuario;
  HttpHelper helper = HttpHelper();
  //autenticationApi _autenticationApi = autenticationApi(_http);
  final logger = Logger();
  final getIt = GetIt.instance;
  final dio = Dio();

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

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
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
              suffixIcon: isEmail(txtCorreo.text) == false
                  ? Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
              hintText: 'Ingresa tu correo',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) {
              setState(() {
                txtCorreo.text;
              });
            },
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
          child: TextField(
            controller: txtPwd,
            obscureText: true,
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
              suffixIcon: txtPwd.text.length < 8
                  ? Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                  : Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
              hintText: 'Ingresar tu contraseña',
              hintStyle: kHintTextStyle,
            ),
            onChanged: (value) {
              setState(() {
                txtPwd.text;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PasswordScreen1(),
              ));
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Olvidaste la contraseña?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Recordar',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (txtCorreo.text.isEmpty) {
            snackBar3Sec(context, "Ingrese su correo electrónico");
          } else if (txtPwd.text.isEmpty) {
            snackBar3Sec(context, "Ingrese su contraseña");
          } else if (isEmail(txtCorreo.text) == false ||
              txtPwd.text.length < 8) {
            snackBar3Sec(context, "El correo o contraseña son incorrectos");
          } else {
            String uid = await logIn(txtCorreo.text, txtPwd.text);

            // _getUserData(context, uid);
            getDataUser(uid, context);
            if (uid.isNotEmpty) {
              print("aaaaaaaaaaaaaaaaaaaaaaa  $uid");
              // final _autenticationApi = GetIt.instance<autenticationApi>();
              // final response = await _autenticationApi.loginSQL(
              //   email: txtCorreo.toString(),
              //   password: txtPwd.toString(),
              // );

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Splash(),
                  ));
            }
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Iniciar Sesión',
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

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- ó -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Iniciar con',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Logueo con Facebook'),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => print('Logueo con Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegistroScreen(),
          )),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'No tienes una cuenta? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Regístrate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startApplication() {
    getIt.registerSingleton<RestClient>(RestClient(dio));
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");

      startApplication();
      setState(() {});
    });
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
                    vertical: 100.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Logo(),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'Inicia Sesión',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40.0),
                      _buildEmailTF(),

                      _buildPasswordTF(),
                      _buildForgotPasswordBtn(),
                      // _buildRememberMeCheckbox(),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Ingresa con "),
                          MaterialButton(
                            onPressed: () {
                              signInWithGoogle();
                            },
                            color: Colors.grey.shade100,
                            child: Image.asset(
                              'assets/images/google_logo.png',
                              height: 30,
                            ),
                            padding: EdgeInsets.all(8),
                            shape: CircleBorder(),
                          ),
                        ],
                      ),
                      _buildLoginBtn(),
                      // _buildSignInWithText(),
                      // _buildSocialBtnRow(),

                      _buildSignupBtn(),
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
      width: 100,
    );
  }
}
