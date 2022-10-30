import 'package:bussines/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:bussines/views/topicProfile.dart';

class ItemList extends StatelessWidget {
  List<Topic> topics;


  ItemList({Key? key, required Topic this.topic, required List<Topic> this.topics}) : super(key: key);
  
  Topic topic;

  @override
  Widget build(BuildContext context) {
    
    return ListTile(
      
      leading: getItemStyle(topic),
      title: Text("${topic.name}"),
      subtitle: Text("Valor: ${topic.value}"),
      onTap: () { 
         Navigator.push(context, MaterialPageRoute(builder: (context) => TopicProfile(topic: topic,)));
       }
    );
    /*
    return SizedBox(
      height: 50,
      //color: Colors.amber[100],
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: InkWell(
              child: Center(child: Text("${topic.name} ${topic.value}", )),
              onTap: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TopicProfile(topic: topic,)))
              },
              ),
          ),
          
        ],
      ),

    );*/
  }

  Widget getItemStyle(topic){

    int status = topic.isUp();

    if(status == 0){
      return  const Icon( Icons.trending_flat_sharp, color: Colors.black);
    }

    if(status == 1){
      return  const Icon( Icons.trending_down_sharp, color: Colors.red);
    }

    if(status == 2){
      return  const Icon( Icons.trending_up_sharp, color: Colors.green);
    }

     return  const Icon( Icons.cached_sharp, color: Colors.black);
  }
}