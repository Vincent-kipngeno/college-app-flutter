import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/string_extension.dart';
import 'package:firebase_database/firebase_database.dart';

class JoinGroup extends StatefulWidget{
  const JoinGroup({Key? key}) : super(key: key);

  @override
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup>{

  final _formKey = GlobalKey<FormState>();

  String? code;
  String? errorMsg;

  void setCode(String? value){
    code = value?? "";
  }

  String? _validateField(String? value) {
    try {
      if (value!.isEmpty) {
        return 'Code should not be empty.';
      }
    } catch (e) {
      return 'Code should not be empty.';
    }

    return null;
  }

  void submit() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        errorMsg = null;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    final codeField = Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        validator: _validateField,
        onSaved: setCode,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: "Enter Code",
          errorText: errorMsg,
          hintText: "Group Code ...",
          hintStyle: const TextStyle(color: Colors.grey),
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

    final joinButton = Container(
      width: 100,
      height: 38,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ElevatedButton(
        child: const Center(child: Text('JOIN'),),
        onPressed: submit,
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: codeField,),
              Align(child: joinButton, alignment: Alignment.center,),
            ]
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: form,
    );

  }
}