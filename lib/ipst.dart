import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

void main()
{
  runApp(myapp());
}

class myapp extends StatelessWidget {
  const myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: IpPage(),
    );
  }
}

class IpPage extends StatefulWidget {
  const IpPage({super.key});

  @override
  State<IpPage> createState() => _IpPageState();
}

class _IpPageState extends State<IpPage> {
  TextEditingController ipController =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ip Page'),backgroundColor: Colors.amber,),
      body: Column(
        children: [
          TextFormField(
            controller: ipController,
            decoration: InputDecoration(labelText: 'Enter your iop'),
          ),
          ElevatedButton(onPressed: sendData, child: Text('connect'))
        ],
      ),
    );
  }
  void sendData() async {
    String ip=ipController.text;
    if(ip.isEmpty){
      Fluttertoast.showToast(msg: 'fill out the field');
      return;
    }
    SharedPreferences sh= await SharedPreferences.getInstance();
    sh.setString("url", "http://$ip:8000/myapp");
    sh.setString("img_url", "http://$ip:8000");
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
