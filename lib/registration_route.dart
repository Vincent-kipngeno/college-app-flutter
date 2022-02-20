import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Registration extends StatefulWidget{
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration>{
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final emailBox = Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "Enter Email",
          labelStyle: const TextStyle(color: Colors.grey),
          fillColor: const Color(0xff213145),
          filled: true,
          contentPadding: const EdgeInsets.all(15),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Color(0xff66C047),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
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
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          //fillColor: Colors.green
        ),
      ),

    );

    final regButton = Container(
        width: 100,
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: ElevatedButton(
          child: const Text('Sign Up'),
          onPressed: () {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing Data')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
              primary: const Color(0xff66C047),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
      );

    final form = Form(
      key: _formKey,
      child: Center(
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(30.0),
            children: [
              Center(child: emailBox,),
              Align(child: regButton, alignment: Alignment.centerLeft,),
            ]
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
      ),
      body: form,
      backgroundColor: const Color(0xff021606),
    );
  }
}