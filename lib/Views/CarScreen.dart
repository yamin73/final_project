import 'dart:convert';
import 'package:final_project/Models/Car.dart';
import 'package:final_project/Utills/DB.dart';
import 'package:final_project/Utills/Utills.dart';
import 'package:flutter/material.dart';
import '../Models/UserModel.dart';
import 'package:final_project/Utills/ClientConfig.dart';
import 'package:http/http.dart' as http;

/*class Carscreen extends StatefulWidget {
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

  void insertUserFunc() {
    if (_txtEmail.text != "" &&
        _txtUserName.text != "" &&
        _txtPassword.text != "") {
      var user = new User();
      user.name = _txtUserName.text;
      user.phone = _txtPhoneNumber.text;
      user.id = _txtID.text;
      user.email = _txtEmail.text;
      user.password = _txtPassword.text;
      // insertUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: getCars(),
          builder: (context, projectSnap) {
            if (projectSnap.hasData) {
              if (projectSnap.data.length == 0) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 2,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text('אין תוצאות',
                          style: TextStyle(fontSize: 23, color: Colors.black))),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                      itemCount: projectSnap.data.length,
                      itemBuilder: (context, index) {
                        Car project = projectSnap.data[index];

                        return Card(
                            child: ListTile(
                          onTap: () {},
                          title: Text(
                            project.carName!,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ), // Icon(Icons.timer),
                          // subtitle: Text("[" + project.ariveHour! + "-" + project.exitHour! + "]" + "\n" + project.comments!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
                          trailing: Container(
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Text(
                              project.carName!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),

                          isThreeLine: false,
                        ));
                      },
                    )),
                  ],
                );
              }
            } else if (projectSnap.hasError) {
              print(projectSnap.error);
              return Center(
                  child: Text('שגיאה, נסה שוב',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)));
            }
            return Center(
                child: new CircularProgressIndicator(
              color: Colors.red,
            ));
          },
        )

        // ),

        );
  }

  Future getCars() async {
    var url = "cars/getCars.php";
    final response = await http.get(Uri.parse(serverPath + url));
    print(serverPath + url);
    List<Car> arr = [];

    for (Map<String, dynamic> i in json.decode(response.body)) {
      arr.add(Car.fromJson(i));
    }

    return arr;
  }
}*/
