import 'package:chat_app/helper/authenticate.dart';
import 'package:chat_app/helper/constants.dart';
import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/signin.dart';
import 'package:chat_app/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'conversation_screen.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;
  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index){
            return ChatRoomsTile(
               snapshot.data.documents[index].data["chatroomId"]
                  .toString().replaceAll("_","" ).replaceAll(Constants.myName, ""),
                snapshot.data.documents[index].data["chatroomId"]
            );
            }
        ) : Container();
      },
    );
  }


  @override
  void initState() {
    getUserInfo();


    // TODO: implement initState
    super.initState();
  }
  getUserInfo() async{
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((val){
      setState(() {
        chatRoomsStream = val;
      });

    });
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => Authenticate()
              ));

            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(
        child: chatRoomList(),
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => SearchScreen()
            ));
          },
        child: Icon(Icons.search),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomsTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=> ConversationScreen(chatRoomId),
        ));
      },
      child: Container(
        color: Colors.black26,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text("${userName.substring(0,1).toLowerCase()}"),
            ),
            SizedBox(width: 8,),
            Text(userName, style: mediumTextStyle(),),
          ],
        ),
      ),
    );
  }
}
