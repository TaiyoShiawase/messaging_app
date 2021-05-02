import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui_starter/helper/helperFunctions.dart';
import 'package:flutter_chat_ui_starter/screens/home_screen.dart';
import 'package:flutter_chat_ui_starter/screens/register_screen.dart';
import 'package:flutter_chat_ui_starter/services/auth.dart';
import 'package:flutter_chat_ui_starter/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color logoGreen = Color(0xff25bcbb);

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  QuerySnapshot snapshotUserInfo;

  signIn(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailController.text, passwordController.text).then((val){
        if(val != null){
          HelperFunctions.saveUserLoggedInSharePreference(true);   

          databaseMethods.getUserByEmail(emailController.text).then((val) {
            snapshotUserInfo = val;
          
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(snapshotUserInfo.docs[0].data()["name"])));
          });     
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: isLoading ? Center(child: CircularProgressIndicator()) : Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/logo.png", height: 200, width: 200),
                Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 25),
                ),
                SizedBox(height: 30),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor, border: Border.all(color: Colors.blue)),
                        child: TextFormField(
                          validator: (val){
                             return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please Provide A Valid Email";
                          },
                          controller: emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white),
                              icon: Icon(
                                Icons.account_circle,
                                color: Colors.white,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Color(0xff232c51), border: Border.all(color: Colors.blue)),
                        child: TextFormField(
                          validator: (val){
                                return val.isEmpty || val.length < 6 ? "Please Provide A Valid Password (Minimum of 6 characters)" : null;
                          },
                          obscureText: true,
                          controller: passwordController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white),
                              icon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              border: InputBorder.none),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                MaterialButton(
                  elevation: 0,
                  minWidth: double.maxFinite,
                  height: 40,
                  onPressed: (){
                      signIn();
                  },
                  color: logoGreen,
                  child: Text('Login',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  textColor: Colors.white,
                ),
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildFooterLogo(),
                )
              ],
            ),
          ),
        ));
  }

  _buildFooterLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('No account yet?',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)
        ),
        TextButton(
          child: Text ('Click here to Register',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(color: logoGreen, fontSize: 15)
          ),
          onPressed: (){
            Navigator.push(
                      context, 
                      MaterialPageRoute
                        (builder: (_) => RegisterScreen()
                      )
                    );
          },
        )
      ],
    );
  }
}