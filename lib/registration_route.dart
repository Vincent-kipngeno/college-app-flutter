import 'package:college_app/Login_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/my_user.dart';
import 'models/string_extension.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef MyValidateCallback = String? Function(String? value);

class Registration extends StatefulWidget{
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration>{
  final _formKey = GlobalKey<FormState>();
  FirebaseDatabase database = FirebaseDatabase.instance;
  final MyUser _user = MyUser();

  String? password;
  String? errorMsg;
  String? passErrMsg;
  DateTime? currentBackPressTime;

  DatabaseReference userRef = FirebaseDatabase.instance.ref("users");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) async {
          
      if (user != null) {
        _user.setUid(user.uid);
        try{
          userRef.child(user.uid).set(_user.userMap()).whenComplete(() => startLoginRoute());
        }
        on Exception catch(e){
          setState(() {
            errorMsg = "Check network connection";
          });
        }
        
      }
      
    });
    
  }

  void startLoginRoute(){
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return const Login();
      },
    ));
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

  String? _validateName(String? value) {
    try {
      if (value!.isEmpty) {
        return 'User Name should not be empty.';
      }
    } catch (e) {
      return 'User name should not be empty.';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    try {
      if (!value!.isValidPhone) {
        return 'Phone Number must be up to 10 digits';
      }
    } catch (e) {
      return 'Phone Number must be up to 10 digits';
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

  String? _validateConfirmPassword(String? value) {
    try {
      if (value! != password) {
        return 'Confirm Password should match password';
      }
    } catch (e) {
      return 'Confirm Password should match password';
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
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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

  void _startLoginRoute(){
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return const Login();
      },
    ));
  }


  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press the back button again");
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final usernameBox = textFormField(
      validateField: _validateName,
      setValue: _user.setUserName,
      label: "Enter username",
      hint: "my name",
      icon: const Icon(Icons.person, size: 20.0, color: Color(0xff66C047)),
      error: null,
      isPassword: false,
    );

    final phoneBox = textFormField(
      validateField: _validatePhone,
      setValue: _user.setPhone,
      label: "Enter phone",
      hint: "0705291094",
      icon: const Icon(Icons.phone, size: 20.0, color: Color(0xff66C047)),
      error: null,
      isPassword: false,
    );

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

    final confirmPasswordBox = textFormField(
      validateField: _validateConfirmPassword,
      setValue: null,
      label: "Enter Confirm Password",
      hint: "Confirm Password",
      icon: const Icon(Icons.lock, size: 20.0, color: Color(0xff66C047)),
      error: null,
      isPassword: true,
    );

    final regButton = Container(
        width: 100,
        height: 38,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: ElevatedButton(
          child: const Text('Sign Up'),
          onPressed: submit,
          style: ElevatedButton.styleFrom(
              primary: const Color(0xff66C047),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
      );

    final loginMsg = Container(
      height: 38,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children:  <Widget>[
          const Text("Already have an account?",
            style: TextStyle(color: Colors.white),),
          TextButton(
            onPressed: _startLoginRoute,
            child: const Text("Login",
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
              Center(child: usernameBox,),
              Center(child: phoneBox,),
              Center(child: emailBox,),
              Center(child: passwordBox,),
              Center(child: confirmPasswordBox,),
              Align(child: loginMsg, alignment: Alignment.centerLeft,),
              Align(child: regButton, alignment: Alignment.centerLeft,),
            ]
        ),
      ),
    );

    return WillPopScope(
        onWillPop: () async => true,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff253412),
            title: const Text("Registration"),
          ),
          body: form,
          backgroundColor: const Color(0xff021606),
        ),
    );
  }
}