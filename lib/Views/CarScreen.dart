import 'package:final_project/Utills/DB.dart';
import 'package:final_project/Utills/Utills.dart';
import 'package:flutter/material.dart';

import '../Models/UserModel.dart';



class Carscreen extends StatefulWidget {
  const Carscreen({super.key, required this.title});



  final String title;

  @override
  State<Carscreen> createState() => _CarScreen();
}

class _CarScreen extends State<Carscreen> {

  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPassword = TextEditingController();
  final TextEditingController _txtUserName = TextEditingController();
  final TextEditingController _txtPhoneNumber = TextEditingController();
  final TextEditingController _txtID = TextEditingController();

  void insertUserFunc()
  {
    if(_txtEmail.text!="" && _txtUserName.text!="" && _txtPassword.text!="")
    {
      var user= new User();
      user.name=_txtUserName.text;
      user.phone =_txtPhoneNumber.text;
      user.id=_txtID.text;
      user.email=_txtEmail.text;
      user.password=_txtPassword.text;
      insertUser(user);
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

      ),

    );
  }
}
