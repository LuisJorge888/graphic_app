import 'dart:convert';
import 'dart:ffi';

import '../providers/businessApi.dart';

BusinessApi ws = BusinessApi();

class Topic {
  int? id;
  String? name;
  String? value;
  int? idLastValue;
  String? updateAt;
  int maxValue;
  int minValue;
  List<OldValue> oldValues = [];

  Topic({this.id, this.name, this.value, this.idLastValue, this.updateAt, required this.maxValue, required this.minValue});

  static getTopicById(idTopic) async {
    dynamic topicRes = await BusinessApi.getTopicById(idTopic);

    if(topicRes == null){
      return null;
    }

  }

  static Future<List<Topic>> getAllTopic() async {
    
    String topicsRes = await BusinessApi.getAllTopic();

    return parseTopic(topicsRes);
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['to_id'] as int,
      name: json['to_name'] as String,
      value: json['to_value'].toString(),
      idLastValue: json['to_va_id'] as int,
      updateAt: json['to_update_at'] as String,
      maxValue: json['to_value'] as int,
      minValue: json['to_value'] as int
    );
  }

  static List<Topic> parseTopic(String responseBody) {

    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Topic>((json) => Topic.fromJson(json)).toList();
  }

  getLastIndex(){
    return (oldValues.isEmpty) ? 0 : oldValues.last.index +1 ;
  }

  List<OldValue> getValues(){

    var values = oldValues.toList();

    values.add(OldValue(getLastIndex(), value!));

    return values;
  }

  isUp(){
    
    if(oldValues.isEmpty){
      return 0;
    }

    int oldValue = int.parse(oldValues.last.value);
    int actualValue = int.parse(value!);

    if(actualValue == oldValue){
      return 0;
    }

    if(actualValue < oldValue){
      return 1;
    }

    return 2;
  }

  int getLastIdOldValues(){

    if(oldValues.isEmpty) {
      return 1;
    }
      
    OldValue last = oldValues.last;
    return (last == null) ? 1 : last.index + 1;
  }
}

class OldValue {
  OldValue(this.index, this.value);

  final int index;
  final String value;
}