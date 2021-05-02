import 'package:flutter/material.dart';
import 'package:flutter_chat_ui_starter/helper/helperFunctions.dart';
import 'package:flutter_chat_ui_starter/screens/home_screen.dart';
import 'package:flutter_chat_ui_starter/screens/login_screen.dart';
import 'package:flutter_chat_ui_starter/services/auth.dart';
import 'package:flutter_chat_ui_starter/services/database.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final Color logoGreen = Color(0xff25bcbb);

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();


  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  signUp(){
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      authMethods.signUpwithEmailAndPassword(emailController.text, passwordController.text).then((val){
        
        Map<String, String> userInfoMap = {
          "name" : nameController.text,
          "email" : emailController.text 
        };

        HelperFunctions.saveUserEmailSharePreference(emailController.text);
        HelperFunctions.saveNameSharePreference(nameController.text);

        databaseMethods.uploadUserInfo(userInfoMap);

        HelperFunctions.saveUserLoggedInSharePreference(true);        
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(nameController.text)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: isLoading ? Center(child: CircularProgressIndicator()) : 
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/logo.png", height: 150, width: 150),
                Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 25),
                ),
                SizedBox(height: 30),
                Form(
                  key: formKey,
                  child:Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Theme.of(context).accentColor, border: Border.all(color: Colors.blue)),
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val){
                                return val.isEmpty ? "Please Provide A Username" : null;
                              },
                              controller: nameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  labelText: 'Username',
                                  labelStyle: TextStyle(color: Colors.white),
                                  icon: Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                  ),
                                  border: InputBorder.none),
                            ),
                          ]
                        )
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Theme.of(context).accentColor, border: Border.all(color: Colors.blue)),
                        child: Column(
                          children: [
                            TextFormField(
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
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  border: InputBorder.none),
                              ),
                            ]
                          )
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
                    onPressed: () {
                      signUp();
                    },
                    color: logoGreen,
                    child: Text('Register',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  // MaterialButton(
                  //   elevation: 0,
                  //   minWidth: double.maxFinite,
                  //   height: 50,
                  //   onPressed: () {
                  //   //Here goes the logic for Google SignIn discussed in the next section
                  //   },
                  //   color: Colors.blue,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: <Widget>[
                  //       Icon(FontAwesomeIcons.google),
                  //       SizedBox(width: 10),
                  //       Text('Sign-in using Google',
                  //           style: TextStyle(color: Colors.white, fontSize: 16)),
                  //     ],
                  //   ),
                  //   textColor: Colors.white,
                  // ),
                  // SizedBox(height: 50),
                  Align(alignment: Alignment.bottomCenter, child: _buildFooterLogo(),
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
        Text('Already have an account?',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)
        ),
        TextButton(
          child: Text ('Click here to Login',
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(color: logoGreen, fontSize: 15)
          ),
          onPressed: (){
            Navigator.push(
                      context, 
                      MaterialPageRoute
                        (builder: (_) => LoginScreen()
                      )
                    );
          },
        )
      ],
    );
  }
}
