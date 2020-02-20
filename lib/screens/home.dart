import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:whatsapp/screens/add.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import '../models/message.dart';
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
        backgroundColor: Colors.black,
        title: Text('Message Scheduler'),
      ),
      drawer: Drawer(
        elevation: 15.0,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
            )
          ],
        ),
      ),
      body: new ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            color: Colors.pink,
            child: ListTile(
              title: Text(list[index].msg),
              subtitle: Text('${list[index].id}'),
              trailing: InkWell(
                child: Icon(Icons.delete),
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
        onPressed: () {
          setState(() async {
            print('button');
            await Navigator.push(
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
