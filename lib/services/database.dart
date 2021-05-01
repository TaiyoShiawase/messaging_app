import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserByName(String name) async{
    return await FirebaseFirestore.instance.collection("users").where("name", isEqualTo: name).get();
  }

  getUserByEmail(String email) async{
    return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: email).get();
  }

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatroom(String chatRoomID, chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomID).set(chatRoomMap);
  }

  saveMessage(String chatRoomID, messageMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomID).collection("chats").add(messageMap);
  }

  getConversation(String chatRoomID) async {
    return await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomID).collection("chats").orderBy("dateSent", descending: false).snapshots();
  }

  getPrivateChatRooms(String name) async {
    return await FirebaseFirestore.instance.collection("ChatRoom").where("users", arrayContains: name).snapshots();
  }
}