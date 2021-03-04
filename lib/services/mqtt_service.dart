abstract class MqttService{

  Future<void> subscribe(String topic);
  Future<void> publish(String topic,String message);

}