import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';
import 'package:remote_app/services/mqtt_service.dart';

enum ServerStatus {
  Online,
  Offline
}

class MqttClientService extends MqttService with ChangeNotifier{

  ServerStatus _serverStatus = ServerStatus.Offline;

  get serverStatus => this._serverStatus;

  MqttServerClient client;

  MqttClientService(){
    this.connect();
  }

  Future<MqttServerClient> connect() async {
    client =
    MqttServerClient.withPort('elroir.ml', 'flutter_client',1883,maxConnectionAttempts: 1);
    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    try {
      await client.connect('elroir', '123456');
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }
    notifyListeners();
    return client;
  }

  // Call this function tu publish a message
  @override
  Future<void> publish(String topic,String message) async {
    if (client != null){
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.atLeastOnce,builder.payload);
    }
  }

  Future<void> subscriptionResponse() async {
    client.updates.listen((event) {
      event.forEach((element) {
        print(element.topic.characters);
        notifyListeners();
      });
    });
  }

  @override
  Future<void> subscribe(String topic) async {
    client.subscribe(topic, MqttQos.atLeastOnce);
  }


  // connection succeeded
  void onConnected() {
    client.connectionStatus.state = MqttConnectionState.connected;
    this._serverStatus = ServerStatus.Online;
    notifyListeners();
  }

// unconnected
  void onDisconnected() {
    client.connectionStatus.state = MqttConnectionState.disconnected;
    this._serverStatus = ServerStatus.Offline;
    notifyListeners();

  }

// subscribe to topic succeeded
  void onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

// subscribe to topic failed
  void onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

// unsubscribe succeeded
  void onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
  }



}