import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  //SAVING DATA TO SHAREDPREFERENCE
  
  static Future<void> saveUserLoggedInSharePreference(bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserLoggedInKey, isUserLoggedIn); 
  }

  static Future<void> saveNameSharePreference(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, username); 
  }

  static Future<void> saveUserEmailSharePreference(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, email); 
  }

  static Future<void> clearSharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    return await prefs.remove(sharedPreferenceUserNameKey);
  }

  //GETTING DATA FROM SHAREDPREFENCE
  
   static Future<bool> getUserLoggedInSharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserLoggedInKey); 
  }

  static Future<String> getNameSharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey); 
  }

  static Future<String> getUserEmailSharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey); 
  }
}