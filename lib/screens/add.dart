import 'package:flutter/material.dart';
import 'package:whatsapp/models/message.dart';
import 'home.dart';
// import 'package:contacts_service/contacts_service.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController nController = new TextEditingController();
  TextEditingController tController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Message'),
        ),
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: TextField(
                controller: nController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Mobile'),
              ),
            ),
            // Row(
            //   children: <Widget>[
            //     TextFormField(
            //       controller: nController,
            //       decoration: InputDecoration(labelText: 'Search Contact'),
            //     ),
            //     InkWell(
            //       child:
            //           IconButton(icon: Icon(Icons.contacts), onPressed: null),
            //     )
            //   ],
            // ),
            Container(
              child: TextField(
                controller: tController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Message'),
              ),
            ),
            MaterialButton(
              color: Colors.pinkAccent,
              onPressed: () {
                setState(() async {
                  obj = Msg(int.parse(nController.text), tController.text);
                  i = await db.insert(obj);
                  obj.setId = i;
                  print(obj.msg + "=====>saved at ");
                  print(i);
                  Navigator.pop(context);
                  setState(() {
                    list.add(obj);
                  });
                });
              },
              child: Text('Save'),
              splashColor: Colors.black26,
            ),
          ],
        ));
  }
}
