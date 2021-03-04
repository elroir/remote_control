import 'package:http/http.dart' as http;
import 'package:remote_app/services/mqtt_service.dart';

class OpenHabService extends MqttService {

  final _url = "https://7bce750856e3.ngrok.io/rest";

  @override
  Future<void> publish(String thing,String message)async {
    final String url = "$_url/items/$thing";

    http.post(url,
        headers: {"Content-Type" : "text/plain", "Accept" : "application/json" },
        body: message
    );
  }

  @override
  Future<void> subscribe(String thing) {
    //final String url = "$_url/events/?topics=smarthome/things/$thing";

    throw UnimplementedError();
  }


}