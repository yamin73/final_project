import 'package:final_project/Utills/DB.dart';
import 'package:final_project/Utills/Utills.dart';
import 'package:final_project/Views/CarScreen.dart';
import 'package:flutter/material.dart';

import '../Models/UserModel.dart';



class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.title});



  final String title;

  @override
  State<RegisterScreen> createState() => RegisterScreenPageState();
}

class RegisterScreenPageState extends State<RegisterScreen> {

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

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('User Name',),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '* First Name',
              ),
              controller: _txtUserName,

            ),
            Text('ID'),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '* ID',
              ),
              controller: _txtID,),
            Text('Email',),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '* Email',
              ),
              controller: _txtEmail,
            ),
            Text('Password',),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '* Password',
              ),

              controller: _txtPhoneNumber,


            ),
        Text('Phone Number'),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: '* Phone Number',
          ),
          controller: _txtPhoneNumber,),




            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Carscreen(title: 'Car Screen',)));

               // var uti = new Utils();
               // uti.showMyDialog(context, _txtUserName.text, _txtEmail.text);

              },
              child: Text('NEXT'),
            )

            
          ],
        ),
      ),

    );
  }
}
