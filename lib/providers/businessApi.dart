import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class BusinessApi {

  static const String urlApi = "10.0.2.2:3000";

  static getTopicById(idTopic) async {
    
    var topic = await BusinessApi.request('/Topic/$idTopic');

    return (topic) ? topic : null;

  }

  static getAllTopic() async {
    
    var topic = await BusinessApi.request('/Topic/');

    return (topic != null) ? topic : null;
  }

  static request(String endPoint) async {

    Uri url = Uri.http(BusinessApi.urlApi, endPoint);

    dynamic res = await http.get(url);


    print('Response status: ${res.statusCode}');
    print('Response body: ${res.body}');

    if (res.statusCode == 200) {
  
      return res.body;
    }

    print("Algo salio mal!!!");
    return null;
  }

}
