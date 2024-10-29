import 'package:final_project/Utills/Utills.dart';
import 'package:flutter/material.dart';



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
            Text('Email',),
            TextField(
              //controller: ,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Email',
              ),
              controller: _txtEmail,
            ),
            Text('Password',),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Password',
              ),
              controller: _txtPassword,

            ),
            Text('User Name',),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'First Name',
              ),
              controller: _txtUserName,

            ),

            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                var uti = new Utils();
                uti.showMyDialog(context, _txtUserName.text, _txtEmail.text);

              },
              child: Text('Register'),
            )


          ],
        ),
      ),

    );
  }
}
