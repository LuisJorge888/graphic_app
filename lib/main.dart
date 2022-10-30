import 'dart:convert';

import 'package:bussines/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bussines/widgets/ItemList.dart';
import 'package:bussines/mqtt/client.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  runApp(const MyApp());
  await dotenv.load(fileName: ".env");
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  
}

class _MyAppState extends State<MyApp> {
  List<Topic> topics = [];
  MqttClient client = MqttClient();

  @override
  void initState() {
    super.initState();

    Topic.getAllTopic().then((topics) => {
      if (topics != null){

        setState(() => {
          this.topics = topics,
          subcribirTopics(topics),

        }),

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Topics',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Topics", style: TextStyle(), textAlign: TextAlign.center),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: topics.length,
            itemBuilder: (BuildContext context, int index) {
              return ItemList(topic: topics[index], topics: topics);
            }
          ),
        )
      )
    );
  }

  showMensaje(idTopic, msg) {

    if(idTopic == "newTopic"){
      Map<String, dynamic> data = jsonDecode(msg);
      Topic newT = Topic.fromJson(data);
      if(topics.indexWhere((element) => element.id.toString() == idTopic) == -1){
        setState(() {
          topics.add(newT);
          if (client.subscribeToTopic(newT.id.toString()) != null) {
            Fluttertoast.showToast(
              msg: "Se a agregado el topic '${newT.name.toString()}'",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color.fromARGB(255, 86, 86, 86),
              textColor: Colors.white,
              fontSize: 15.0,
            );
          }
        });
      }
      return;
    }

    

    int index = topics.indexWhere((element) => element.id.toString() == idTopic);
    
    if(index >= 0){
      setState(() {

       
        if( topics[index].oldValues.length > 10){
          topics[index].oldValues.removeAt(0);
        }

        topics[index].oldValues.add(OldValue(topics[index].getLastIdOldValues(), topics[index].value!));
        
        topics[index].value = msg;
       
        if(topics[index].maxValue < num.parse(msg)){
          topics[index].maxValue = int.parse(msg);
        }

        if(topics[index].minValue > num.parse(msg)){
          topics[index].minValue = int.parse(msg);
        }


      });
    }
  }

  subcribirTopics(topics) async {
    var conected = await client.conectMqtt(dotenv.env['MQTT_SERVER']!,dotenv.env['MQTT_CLIENT_ID']!);
    print("conecto? $conected");
    if(conected){
      topics.forEach((t) {
        if (client.subscribeToTopic(t.id.toString()) != null) {
          //print("Conectado a ${t.id.toString()}");
          
        }
      });
      
      if (client.subscribeToTopic("newTopic") != null) {
        print("Esperando a newTopic");
      }
      client.onMessage(showMensaje);
    }
        
  }
}

/**
 * 
 * 
 * (topics != []) ?
          ListView.builder(
            itemCount: topics.length,
            itemBuilder: (BuildContext context, int index) {
              // access element from list using index
	          // you can create and return a widget of your choice
              return ItemList(topic:topics[index]);
            })
          :
          const Text("HOLI"),
 */

/**
 * 
                  (topics != [])
                      ? ListView.builder(
                          itemCount: topics.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ItemList(topic: topics[index]);
                          })
                      : const Text("HOLI"),/*
                  ElevatedButton(
                    onPressed: () async {
                      await client.conectMqtt(dotenv.env['MQTT_SERVER']!,
                          dotenv.env['MQTT_CLIENT_ID']!);
                      if (client.subscribeToTopic("1") != null) {
                        client.onMessage(showMensaje);
                      }
                    },
                    child: Text('MQTT'),
                  )*/
 * 
 */