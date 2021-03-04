import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void connectionAlert(BuildContext context,String title, String content,Future<MqttServerClient> connection) {

  if (Platform.isAndroid) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              child: Text('ok'),
              onPressed: () async {
                await connection;
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
              onPressed: () async {
                await connection;
                Navigator.of(context).pop();
              },
            ),
          ],
        )
    );

  }
}