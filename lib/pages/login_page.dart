import 'package:flutter/material.dart';
import 'package:template/presenters/login_presenter.dart';
import 'package:template/auth/auth.dart';

// import 'package:template/pages/acciones_page.dart';

import 'package:template/models/user.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
  with SingleTickerProviderStateMixin implements LoginScreenContract, AuthStateListener{
  // Animation<double> _iconAnimation;
  // AnimationController _iconAnimationController;

  bool _value1 = false;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  bool _autoValidate = false;
  int _descargando = 0;
  dynamic usuario = "";
  String _pass;


  BuildContext _ctx;

  void _value1Changed(bool value) => setState(() => _value1 = value);

  LoginScreenPresenter _presenter;

  LoginPageState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void onLoginError(String errorTxt) {
    // _showSnackBar(errorTxt);
    _showAlert(errorTxt);
    setState(() {
        _isLoading = false;
        _descargando=0;
      }
    );
  }

  @override
  void onLoginSuccess(User user) async {
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }
  
  @override
  void onDownloading(int descarga) async {
    setState(() => _descargando=descarga);
  }

    @override
  void onInmobiliariaError(String errorTxt) {
    // _showSnackBar(errorTxt);
    _showAlert(errorTxt);
    setState(() {
        _isLoading = false;
        _descargando=0;
      }
    );
  }

  @override
  void onInmobiliariaSuccess(int response) async {
    //print('success inmobiliaria');
    setState(() {
        _isLoading = false;
      }
    );
  }
  
  @override
  void dispose() {
    var authStateProvider = new AuthStateProvider();
    authStateProvider.dispose(this);
    super.dispose();
  }

  void _submit() {
    final form = formKey.currentState;
    print("estee es el user ${_username.text.toString()}");
     
    if (form.validate()) {
      // int usuario = 0;
      print("ifff");
      form.save();
      print("despues del form");

      try{
      print("tryyy");

        usuario = _username.text.toString();
        _pass =  _password.text.toString();
      }
      on Exception catch(error){
         _showAlert("Usuario y/o contraseña incorrectos 1.");
      }

      if(usuario.length>0){
        print("aquiiiiiiiiiiiii");
        setState(() => _isLoading = true);  
        
        _presenter.doLogin(usuario,_pass);
      }
      else{
        _showAlert("Usuario y/o contraseña incorrectos 2.");
      }
    }
    else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  onAuthStateChanged(AuthState state) {
    print('state login $state');
    if(state == AuthState.LOGGED_IN){
      // Navigator.of(_ctx).pushNamedAndRemoveUntil('/proyectos', (Route<dynamic> route) => false);
      // Navigator.push(_ctx, MaterialPageRoute(builder: (_ctx) => AccionesPage(user:usuario, pass:_pass)));
    } 
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;

    return new Scaffold(
      backgroundColor: Colors.white,
      body: 
      new Stack(fit: StackFit.expand, children: <Widget>[
        new Theme(
          data: new ThemeData(
              brightness: Brightness.light,
              inputDecorationTheme: new InputDecorationTheme(
                labelStyle:
                    new TextStyle(color: Colors.black, fontSize: 16.0),
              )),
            isMaterialAppTheme: true,
            child: new SingleChildScrollView(
              child: _descargando==0 ?  new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[              
              new Padding(
                padding: const EdgeInsets.only(top: 120.0),
              ),
              new Image(
                image: new AssetImage("assets/images/template-logo.jpg"),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 60.0),
              ),
              new Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                // decoration: new BoxDecoration(
                //   image: new DecorationImage(
                //     image: new AssetImage("assets/images/login-marcadeagua.png"),
                //     fit: BoxFit.fitWidth,
                //     alignment: Alignment.bottomCenter,
                    
                //   ),
                // ),
                child: new Form(
                  key: formKey,
                  autovalidate: _autoValidate,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: new Column(
                          children:  <Widget>[
                            new TextFormField(
                              controller: _username,
                              decoration: new InputDecoration(
                                  labelText: "Usuario", fillColor: Colors.grey
                              ),
                              keyboardType: TextInputType.text,
                              validator: (_username) {
                                return _username.length ==0
                                    ? "El usuario es requerido"
                                    : null;
                              },
                            ),
                            new Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                            ),
                            new TextFormField(
                              controller: _password,
                              decoration: new InputDecoration(
                                labelText: "Contraseña",
                              ),
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              validator: (_password) {
                                return _password.length ==0
                                    ? "La contraseña es requerida"
                                    : null;
                              },
                            ),
                          ],
                        )
                      ),
                      
                      new CheckboxListTile(
                        value: _value1,
                        onChanged: _value1Changed,
                        title: new Text("Recordar contraseña"),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                                  
                      
                      new Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      
                     _isLoading ? loadingButton(context) : loginButton(context),
                     
                    ],
                  ),
                ),
              )
            ],
          ) :  descargandoWidget(),
        ),
        ),
      ]),
    );
    
  }
  
  Widget loginButton(BuildContext context){
    return new MaterialButton(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                        height: 40.0,
                        color: Theme.of(context).accentColor,
                        splashColor: Colors.teal,
                        textColor: Colors.black,
                        child: new Text("INGRESAR", style: TextStyle(fontSize:15)),
                        onPressed:  (){
                           _submit();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => AccionesPage()),
                          // );
                        },
                        
                      );
  }

  Widget loadingButton(BuildContext context){
    return new MaterialButton(
                        height: 40.0,
                        minWidth: 100,
                        color: Theme.of(context).accentColor,
                        splashColor: Colors.teal,
                        textColor: Colors.black,
                        child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),),
                        onPressed:  (){
                         
                        },
                        
                      );
  }

  Widget descargandoWidget(){

    return Container(
            height: MediaQuery.of(context).size.height,
            child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                      ),
                      
                      new Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                      ),
                      new CircularProgressIndicator(),
                      new Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                      ),
                      new Text("Actualizando..", style: new TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ])
            );
  }
  
  _showAlert(String error){
    return showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context){
            return AlertDialog(
                title: Text("LOGIN"),
                content: SingleChildScrollView(
                    child: ListBody(
                        children: <Widget>[
                            Text(error)
                        ]
                    )
                ),
                actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  },
                                child: Text('ACEPTAR', style: TextStyle(color: Colors.black))
                            )
                        ]
                );
            }
        );
  }
}

class MyClipper extends CustomClipper<Path> {
      @override
      Path getClip(Size size){
        var path = new Path();
        var firstpoint = new Offset(0.0, size.height*0.5);
        var other  =  new Offset(size.width, size.height*0.5);
        path.quadraticBezierTo(firstpoint.dx,firstpoint.dy, other.dx, other.dy);
        path.close();
        return path;
      }

      @override
      bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}