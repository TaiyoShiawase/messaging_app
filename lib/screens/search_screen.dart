import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui_starter/helper/constants.dart';
import 'package:flutter_chat_ui_starter/screens/chat.dart';
import 'package:flutter_chat_ui_starter/services/database.dart';

// import 'chat_screen.dart';

class SearchScreen  extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final formKey = GlobalKey<FormState>();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchController = TextEditingController();

  QuerySnapshot searchSnapshot;

  initiateSearch(){
    if(formKey.currentState.validate()){
      databaseMethods.getUserByName(searchController.text).then((val){
        setState(() {
          searchSnapshot = val;  
        });
      });
    }
  }

  createChatroomAndStartConversation(String username){
    if(username != Constants.myName){
      String chatRoomID = getChatroomID(username, Constants.myName);

      List<String> users = [username, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomID": chatRoomID
      };

      databaseMethods.createChatroom(chatRoomID, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(chatRoomID, username)));
    }else{
      print("You Cannot Search Yourself");
    }
  }

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
      itemCount: searchSnapshot.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return  GestureDetector (
        onTap: (){
          createChatroomAndStartConversation(searchSnapshot.docs[index].data()["name"]);
        }, 
        child: searchTile(
            searchSnapshot.docs[index].data()["name"], 
            searchSnapshot.docs[index].data()["email"],
            false
          )
        );
      }) : Container();
  }

  Widget searchTile(String name, String email, bool trial) {
    return Container(
      margin: EdgeInsets.only(top: 15.0, bottom: 5.0, right: 10.0, left: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0)
        )  
      ),
      child: Row (
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 35.0, 
                backgroundImage: AssetImage("assets/images/panda.jpg"),
              ),
              SizedBox(
                width: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      color:  Colors.black54,
                      fontSize: 23.0,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: Text(
                      email,
                      style: TextStyle(
                        color:  Colors.blueGrey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ] 
              )
            ]
          ),
          Column(
            children: <Widget>[
              Text(
                "1:59 pm",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 5.0),
              trial ? Container(
              width: 40.0,
              height: 20.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              alignment: Alignment.center,
              child: Text(
                'NEW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ) : SizedBox.shrink(),
            ]
          )
        ]
      )
    );
  }

  getChatroomID(String a, String b){
    if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Theme.of(context).accentColor,
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Row(
                children: [
                  Form(
                    key: formKey,
                    child: Expanded(
                        child: TextFormField(
                          validator: (val){
                                return val.isEmpty ? "Please Provide A Name" : null;
                          },
                          controller: searchController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search username...',
                            hintStyle: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                          )
                        ),
                      ),
                    ),
                  IconButton(
                    color: Colors.white, 
                    icon: Icon(Icons.search_rounded),
                    onPressed: (){
                      initiateSearch();
                    },
                  )
                ]
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}



