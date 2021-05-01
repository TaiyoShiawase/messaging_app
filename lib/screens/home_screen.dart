import 'package:flutter/material.dart';
import 'package:flutter_chat_ui_starter/helper/constants.dart';
import 'package:flutter_chat_ui_starter/helper/helperFunctions.dart';
import 'package:flutter_chat_ui_starter/screens/search_screen.dart';
import 'package:flutter_chat_ui_starter/services/auth.dart';
import 'package:flutter_chat_ui_starter/services/database.dart';
import 'package:flutter_chat_ui_starter/widgets/category_selector.dart';
import 'chat.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream privateChatrooms;

  @override
  void initState() {
    getUserInfo();

    databaseMethods.getPrivateChatRooms(Constants.myName).then((value){
      privateChatrooms = value;
    });
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getNameSharePreference();
    print(Constants.myName);
    databaseMethods.getPrivateChatRooms(Constants.myName).then((value){
      privateChatrooms = value;
    });
    setState(() {});
  }

  Widget chatRoomList(){
    return StreamBuilder(
      stream: privateChatrooms,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.size,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector (
                onTap: () => 
                Navigator.push(
                  context, 
                  MaterialPageRoute
                    (builder: (context) => ChatScreen(snapshot.data.docs[index].data()["chatroomID"], snapshot.data.docs[index].data()["chatroomID"].toString().replaceAll("_", "").replaceAll(Constants.myName, ""))
                  )
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFEFEE),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0)
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
                                snapshot.data.docs[index].data()["chatroomID"].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                                style: TextStyle(
                                  color:  Colors.grey,
                                  fontSize: 25.0,
                                ),
                              ),
                            ] 
                          )
                        ]
                      ),
                  ]
                )
              )
            );
        }) : Container();
      },
    );
  }

  Widget privateChatRoomsTile(){
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child:ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: chatRoomList(),        
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        leading: Transform.translate(
          offset: Offset(-5, 0),
          child: Icon(Icons.messenger_rounded),
        ),
        titleSpacing: -17,
        centerTitle: false,
        title: Text(
          Constants.myName,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              HelperFunctions.saveUserLoggedInSharePreference(false);
              Constants.myName = " ";
              authMethods.signOut();
              Navigator.push(
                context, 
                MaterialPageRoute
                  (builder: (_) => LoginScreen()
                )
              );
            },
          ),
        ],
      ),
      floatingActionButton: 
        FloatingActionButton(
          child:  Icon(Icons.search),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => SearchScreen()
            ));
          },
        ),
      body: Column(
        children: <Widget>[
          CategorySelector(),
          Expanded (
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )
              ),
              child:  Column(
                children: <Widget>[
                  privateChatRoomsTile(),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}