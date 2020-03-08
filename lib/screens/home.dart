import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:whatsapp/screens/add.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import '../models/message.dart';
import 'dart:async';
// import 'package:contacts_service/contacts_service.dart';

class MsApp extends StatefulWidget {
  @override
  _MsAppState createState() => _MsAppState();
}

MsgProvider db = MsgProvider();
List<Msg> list = <Msg>[];
Msg obj;
var i;

class _MsAppState extends State<MsApp> {
  @override
  void initState() {
    super.initState();
    _getMsgs();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text('Message Scheduler'),
      ),
      drawer: Drawer(
        elevation: 15.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Image(
              image: AssetImage(
                "lib/assets/minion.png",
              ),
              height: 280,
              width: 280,
            ))
          ],
        ),
      ),
      body: new ListView.builder(
        physics: ScrollPhysics(parent: BouncingScrollPhysics()),
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            color: Colors.blueAccent,
            child: ListTile(
              title: Text(
                '${list[index].name}',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                list[index].msg,
                maxLines: 2,
                style: TextStyle(color: Colors.white),
              ),
              trailing: InkWell(
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onTap: () {
                  _delete(index);
                },
              ),
              // leading: InkWell(
              //   child: Icon(Icons.send),
              //   onTap: () {

              //   },
              // ),
              onTap: () {
                FlutterOpenWhatsapp.sendSingleMessage(
                    '${list[index].number}', '${list[index].msg}');
              },
            ),
          );
        },
        itemCount: list.length,
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        splashColor: Colors.greenAccent,
        hoverElevation: 18,
        focusElevation: 18,
        highlightElevation: 18,
        onPressed: () {
          setState(() {
            print('button');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Add()));
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _delete(int index) async {
    var i = await db.delete(list[index].id);
    setState(() {
      print('deleted $i');
      list.removeAt(index);
    });
  }

  Future<void> _getMsgs() async {
    var data = await db.getAll();
    setState(() {
      data.forEach((item) {
        list.add(Msg.fromMap(item));
        print("import done....");
      });
    });
  }
}
