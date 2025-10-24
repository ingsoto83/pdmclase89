import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _mAuth = FirebaseAuth.instance;
  bool _isPassVisible = false;
  final _key = GlobalKey<FormState>();
  String user ='';
  String pass ='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _key,
        child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(32),
                child: FlutterLogo(size: 120,),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  validator: (value) => value!.isEmpty ? "Ingrese su correo electrónico..." : !value.contains("@") ? "Correo inválido...!" : null,
                  onSaved: (value) => user = value??'',
                  decoration: InputDecoration(
                    labelText: "Correo Electrónico",
                    hintText: "Ingrese su correo electrónico",
                    labelStyle: TextStyle(color:Colors.indigo),
                    isDense: true,
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      gapPadding: 10
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo)
                    )
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  obscureText: !_isPassVisible,
                  validator: (value) => value!.isEmpty ? "Ingrese su contraseña..." : value.length < 6 ? "Debe ser mínimo de 6 caracteres...!" : null,
                  onSaved: (value) => pass = value??'',
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    hintText: "Ingrese su contraseña",
                    labelStyle: TextStyle(color:Colors.indigo),
                    isDense: true,
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: GestureDetector(
                        onTap: (){
                          _isPassVisible = !_isPassVisible;
                          setState(() {});
                        },
                        child: Icon(_isPassVisible ? Icons.visibility_off : Icons.visibility)
                    ),
                    border: OutlineInputBorder(
                      gapPadding: 10
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.indigo)
                    )
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white
                    ),
                    onPressed: (){
                      if(_key.currentState!.validate()){
                        _key.currentState!.save();
                        login();
                      }
                    },
                    child: Text("Iniciar Sesión"))
              )
            ],
        ),
      ),
    );
  }

  void login() async {
    try {
      await _mAuth.signInWithEmailAndPassword(
          email: user, password: pass);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Row(
                children: [
                  Icon(Icons.error, color: Colors.white,),
                  SizedBox(width: 10,),
                  Expanded(child: Text(e.toString(), style: TextStyle(color: Colors.white, fontSize: 13),))
                ],
              )
          )
      );
    }
  }
}
