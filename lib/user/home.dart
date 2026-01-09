import 'package:counsel/user/advocate_request.dart';
import 'package:counsel/user/check_case.dart';
import 'package:counsel/user/feedback.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Userhome"),),
    body: Center(child: Column(children: [
      ElevatedButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>check_case()));

        }, child: Text("Check Case")),
      ElevatedButton(onPressed: (){}, child: Text("History")),
      ElevatedButton(onPressed: (){

        Navigator.push(context, MaterialPageRoute(builder: (context)=>view_advocate()));

      }, child: Text("Advocates")),
      ElevatedButton(onPressed: (){}, child: Text("Notification")),
      ElevatedButton(onPressed: (){}, child: Text("View Complaints")),
      ElevatedButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context)=>feedback()));}, child: Text("Feedback")),
      ElevatedButton(onPressed: (){}, child: Text("Logout")),

    ],),),
    );
  }
}
