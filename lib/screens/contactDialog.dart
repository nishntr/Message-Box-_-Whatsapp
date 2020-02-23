import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'add.dart';

Future<Contact> contactDiag(BuildContext context, List<Contact> contact) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Contact'),
          content: Container(
            constraints: BoxConstraints(maxHeight: 360),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: contact.length,
                itemBuilder: (context, index) {
                  return FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(contact[index]);
                      print(
                          '${contact[index].givenName + contact[index].androidAccountName}');
                      print(
                          '${contact[index].phones.first.value.replaceAll("+91", "")}');
                    },
                    child: Text('${contact[index].givenName}'),
                    color: Colors.blueAccent,
                    splashColor: Colors.lightBlue,
                  );
                }),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'))
          ],
        );
      });
}

Future<List<Contact>> refreshContacts() async {
  List<Contact> contacts;
  PermissionStatus permissionStatus = await _getContactPermission();
  if (permissionStatus == PermissionStatus.granted) {
    // Load without thumbnails initially.
    contacts =
        (await ContactsService.getContacts(withThumbnails: false)).toList();

    contacts.removeWhere((item) => item.androidAccountName != 'WhatsApp');

//      var contacts = (await ContactsService.getContactsForPhone("8554964652"))
//          .toList();

  } else {
    _handleInvalidPermissions(permissionStatus);
  }
  return contacts;
}

Future<PermissionStatus> _getContactPermission() async {
  PermissionStatus permission =
      await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
  if (permission != PermissionStatus.granted &&
      permission != PermissionStatus.disabled) {
    Map<PermissionGroup, PermissionStatus> permissionStatus =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.contacts]);
    return permissionStatus[PermissionGroup.contacts] ??
        PermissionStatus.unknown;
  } else {
    return permission;
  }
}

void _handleInvalidPermissions(PermissionStatus permissionStatus) {
  if (permissionStatus == PermissionStatus.denied) {
    throw new PlatformException(
        code: "PERMISSION_DENIED",
        message: "Access to location data denied",
        details: null);
  } else if (permissionStatus == PermissionStatus.disabled) {
    throw new PlatformException(
        code: "PERMISSION_DISABLED",
        message: "Location data is not available on device",
        details: null);
  }
}
