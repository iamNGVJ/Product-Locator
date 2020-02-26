import 'package:flutter/material.dart';
import 'package:link/screens/all/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomMenu {

  void showMenuOnScreen(context) async{
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Container(alignment: Alignment.center ,child: Text("Settings Menu", style: TextStyle(fontSize: 30),)),
              content: Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileScreen())
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "PROFILE",
                          style: TextStyle(
                            fontSize: 20
                          )
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "REFRESH LOCATION",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "CHANGE PASSWORD",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "LOGOUT",
                        style: TextStyle(
                          fontSize: 20
                        ),
                      ),
                    )
                  ],
              )
            )
          );
        });
  }
}
