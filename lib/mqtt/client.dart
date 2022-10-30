import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MqttClient {

  late MqttServerClient mqttConexion;

  conectMqtt(String serverHostMqtt, String idClientMqtt) async {

    mqttConexion = MqttServerClient(serverHostMqtt, idClientMqtt);
    //mqttConexion.logging(on: true);
    
    try {

      await mqttConexion.connect();
      if (mqttConexion.connectionStatus!.state == MqttConnectionState.connected) {
        mqttConexion.onConnected = onConnected;
        mqttConexion.onDisconnected = onDisconnected;
        mqttConexion.onSubscribed = onSubscribed;
        return true;
      }else{
        throw NoConnectionException;
      }


    } on NoConnectionException catch (e) {
      print('Error::client exception - $e');
      mqttConexion.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('Error::socket exception - $e');
      mqttConexion.disconnect();
    }
    return false;
  }

  void onConnected(){
    print('Mqtt::client conectado!!');
  }
  void onDisconnected(){
    print('Mqtt::client desconectado!!');
  }

  void onSubscribed(String topic){
    print('Mqtt::client conectado al topic llamado $topic!!');
  }

  MqttServerClient? subscribeToTopic(String idTopic){

    return mqttConexion.subscribe(idTopic, MqttQos.atMostOnce) == null ? null : mqttConexion;
  }

  MqttServerClient? getMqttClient(){
    return mqttConexion;
  }

  void onMessage(myVoidCallback){
    mqttConexion.published!.listen((MqttPublishMessage message) {
      final String msgBody = MqttPublishPayload.bytesToStringAsString(message.payload.message);
      myVoidCallback(message.variableHeader!.topicName,msgBody);
    });
  }

}