import 'dart:io';

import 'package:college_app/joinGroup_route.dart';
import 'package:college_app/registration_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/string_extension.dart';
import 'package:firebase_database/firebase_database.dart';

typedef MyValidateCallback = String? Function(String? value);

class Login extends StatefulWidget{
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginData{
  late String email, password;

  void setEmail(String? value){
    email = value?? "";
  }

  void setPassword(String? value){
    password = value?? "";
  }
}

class _LoginState extends State<Login>{

  final _formKey = GlobalKey<FormState>();
  FirebaseDatabase database = FirebaseDatabase.instance;
  final _LoginData _user = _LoginData();

  String? password;
  String? errorMsg;
  String? passErrMsg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        _navigateToJoinGroup(context);
      }
    });
  }

  String? _validateEmail(String? value) {
    try {
      if (!value!.isValidEmail) {
        return 'The E-mail Address must be a valid email address.';
      }
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    password = value;
    try {
      if (!value!.isValidPassword) {
        return 'Should be uppercase, lowercase, numeric digit and special character';
      }
    } catch (e) {
      return 'Should be uppercase, lowercase, numeric digit and special character';
    }

    return null;
  }

  void submit() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        errorMsg = null;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _user.email,
            password: _user.password
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          setState(() {
            passErrMsg = 'The password provided is too weak.';
          });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            errorMsg = 'The account already exists for that email.';
          });
        }
      } catch (e) {
        SnackBar(content: Text(e.toString()));
      }
    }
  }

  Widget textFormField({required MyValidateCallback validateField,
    required ValueChanged<String?>? setValue,
    required String label,
    required String hint,
    required Icon icon,
    required String? error,
    required bool isPassword,})
  {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        obscureText: isPassword,
        validator: validateField,
        onSaved: setValue,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: label,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          errorText: error,
          labelStyle: const TextStyle(color: Colors.grey),
          fillColor: const Color(0xff213145),
          filled: true,
          contentPadding: const EdgeInsets.all(15),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Color(0xff66C047),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Color(0xff66C047),
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          //fillColor: Colors.green
        ),
      ),

    );
  }

  void startRegistrationRoute(){
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return const Registration();
      },
    ));
  }

  void _navigateToJoinGroup(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return const JoinGroup();
      },
    ),);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final emailBox = textFormField(
      validateField: _validateEmail,
      setValue: _user.setEmail,
      label: "Enter Email",
      hint: "you@gmail.com",
      icon: const Icon(Icons.email, size: 20.0, color: Color(0xff66C047)),
      error: errorMsg,
      isPassword: false,
    );

    final passwordBox = textFormField(
      validateField: _validatePassword,
      setValue: _user.setPassword,
      label: "Enter Password",
      hint: "Password",
      icon: const Icon(Icons.lock, size: 20.0, color: Color(0xff66C047)),
      error: null,
      isPassword: true,
    );

    final loginButton = Container(
      width: 100,
      height: 38,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        child: const Center(child: Text('Login'),),
        onPressed: submit,
        style: ElevatedButton.styleFrom(
            primary: const Color(0xff66C047),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
    );

    final signupMsg = Container(
      height: 38,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children:  <Widget>[
          const Text("Do not have an account yet?",
            style: TextStyle(color: Colors.white),),
          TextButton(
              onPressed: startRegistrationRoute,
              child: const Text("Sign Up",
                style: TextStyle(color: Color(0xff66C047)),
              ),
          ),
        ],
      ),
    );
    final form = Form(
      key: _formKey,
      child: Center(
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(50.0),
            children: [
              Center(child: emailBox,),
              Center(child: passwordBox,),
              Align(child: signupMsg, alignment: Alignment.centerLeft,),
              Align(child: loginButton, alignment: Alignment.centerLeft,),
            ]
        ),
      ),
    );

    return WillPopScope(
        onWillPop: () async  {
          exit(0);
          return false;
          },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff253412),
            title: const Text("Login"),
          ),
          body: form,
          backgroundColor: const Color(0xff021606),
        ),
    );

  }
}