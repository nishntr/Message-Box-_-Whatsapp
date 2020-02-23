import 'package:flutter/material.dart';
import 'package:whatsapp/models/message.dart';
import 'package:whatsapp/screens/contactDialog.dart';
import 'home.dart';
import 'dart:async';
import 'package:contacts_service/contacts_service.dart';
import 'contactDialog.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

TextEditingController nController = new TextEditingController();
TextEditingController tController = new TextEditingController();

class _AddState extends State<Add> {
  List<Contact> _contact;
  Contact recp;
  @override
  void initState() {
    super.initState();
    ref();
    nController.clear();
    tController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('New Message'),
        ),
        // backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Container(
            //   child: TextField(
            //     controller: nController,
            //     keyboardType: TextInputType.number,
            //     decoration: InputDecoration(labelText: 'Mobile'),
            //   ),
            // ),
            Row(
              children: <Widget>[
                Container(
                  width: 0.85 * (MediaQuery.of(context).size.width),
                  child: TextFormField(
                    style: TextStyle(),
                    controller: nController,
                    onFieldSubmitted: (String s) {
                      print(s);
                    },
                    decoration: InputDecoration(
                        focusColor: Colors.greenAccent,
                        hintText: 'Mobile',
                        labelStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.contacts,
                      color: Colors.blue,
                    ),
                    splashColor: Colors.blueAccent,
                    onPressed: () async {
                      recp = await contactDiag(context, _contact);
                      nController.text =
                          recp.phones.first.value.replaceAll(' ', '');
                      if (nController.text.startsWith('+91') == false) {
                        nController.text = '+91' + nController.text;
                        nController.text.replaceAll(" ", null);
                        print(nController.text);
                      }
                    }),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 30)),
            Container(
              child: TextField(
                scrollPhysics: ScrollPhysics(
                    parent: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics())),
                scrollController: ScrollController(keepScrollOffset: true),
                keyboardAppearance: Brightness.dark,
                textInputAction: TextInputAction.newline,
                maxLines: 12,
                scrollPadding: EdgeInsets.all(2),
                minLines: 4,
                style: TextStyle(fontSize: 18),
                onSubmitted: (String s) {
                  print(s);
                },
                controller: tController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hoverColor: Colors.yellow,
                    fillColor: Colors.black45,
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.only(bottom: 5),
                    hintText: 'Message',
                    hintStyle: TextStyle(color: Colors.grey)),
              ),
            ),
            MaterialButton(
              color: Colors.pinkAccent,
              onPressed: () {
                setState(() async {
                  obj = Msg(recp.displayName, int.parse(nController.text),
                      tController.text);
                  i = await db.insert(obj);
                  obj.setId = i;
                  print(obj.msg + "=====>saved at ");
                  print(i);
                  Navigator.pop(context);
                  list.add(obj);
                });
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
              splashColor: Colors.black26,
            ),
          ],
        ));
  }

  Future<void> ref() async {
    _contact = await refreshContacts();
  }
}
