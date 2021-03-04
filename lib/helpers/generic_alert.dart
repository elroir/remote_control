import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void genericAlert(BuildContext context,String title, String content) {

  if (Platform.isAndroid) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );
  } else {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              child: Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );

  }
}