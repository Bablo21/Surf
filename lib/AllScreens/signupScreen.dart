import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:surf_app/AllScreens/loginScreen.dart';
import 'package:surf_app/AllScreens/mainScreen.dart';
import 'package:surf_app/AllWidgets/progressDialog.dart';
import 'package:surf_app/main.dart';


class SignupScreen extends StatefulWidget {

  static const String idScreen = "register";

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameTextEditingController = TextEditingController();

  TextEditingController emailTextEditingController = TextEditingController();

  TextEditingController phoneTextEditingController = TextEditingController();

  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: todo
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              Image(
                image: AssetImage("images/surflogo.JPG"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),

              /* SizedBox(height: 1.0,),
              Text(
                "",
                style: TextStyle(fontSize: 24.0),
                textAlign: TextAlign.center,
              ),*/

              Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [

                      SizedBox(height: 1.0,),
                      TextField(
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(height: 1.0,),
                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(height: 1.0,),
                      TextField(
                        controller: phoneTextEditingController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(height: 1.0,),
                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.0,
                          ),
                        ),
                        style: TextStyle(fontSize: 14.0),
                      ),

                      SizedBox(height: 20.0,),
                      RaisedButton(
                        color: Colors.purple,
                        textColor: Colors.white,
                        child: Container(
                          height: 50.0,
                          child: Center(
                            child: Text(
                              "Create Account",
                              style: TextStyle(
                                  fontSize: 18.0, fontFamily: "Brand-Bold"),
                            ),
                          ),
                        ),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24.0),
                        ),
                        onPressed: () {
                          if (nameTextEditingController.text.length < 3)
                          {
                            displayToastMessage("Name must be at least 2 characters.", context);
                          }
                          else if (!emailTextEditingController.text.contains("@"))
                          {
                              displayToastMessage("Email address is not valid", context);
                          }
                          else if (phoneTextEditingController.text.isEmpty)
                          {
                            displayToastMessage("Phone Number is mandatory", context);
                          }
                          else if (passwordTextEditingController.text.length < 6)
                          {
                            displayToastMessage("Password must be at least 5 characters", context);
                          }
                          else
                          {
                            registerNewUser(context);
                          }
                        },
                      ),

                    ],
                  ),
              ),

              FlatButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                },
                child: Text(
                  "Already have an Account? Login.",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

   void registerNewUser(BuildContext context) async
   {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return ProgressDialog(message: "Registering, Please wait...",);
        }
    );

     final User firebaseUser = (await _firebaseAuth
         .createUserWithEmailAndPassword(
         email: emailTextEditingController.text,
         password: passwordTextEditingController.text
     ).catchError((errMsg){
       Navigator.pop(context);
       displayToastMessage("Error: " + errMsg.toString(), context);
     })).user;

     if(firebaseUser != null) //user created
     {
       //save user info to database
       Map userDataMap = {
         "name": nameTextEditingController.text.trim(),
         "email": emailTextEditingController.text.trim(),
         "phone": phoneTextEditingController.text.trim(),
       };

       usersRef.child(firebaseUser.uid).set(userDataMap);
       displayToastMessage("Congratulations, your account has been created.", context);

       Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
     }
     else
     {
       Navigator.pop(context);
       //error occurred - display error message
       displayToastMessage("New User Account has not been Created.", context);
     }
  }
}

displayToastMessage(String message, BuildContext context)
{
  Fluttertoast.showToast(msg: message);
}