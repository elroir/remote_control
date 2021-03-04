import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote_app/services/mqtt_client.dart';
import 'package:remote_app/views/bottom_bar.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MqttClientService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Control remoto',
        theme: ThemeData.dark(),
        home: BottomBar(),
      ),
    );
  }
}
