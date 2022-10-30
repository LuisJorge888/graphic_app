import 'dart:ui';

import 'package:bussines/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class TopicAll extends StatefulWidget {
  List<Topic> topics;

  TopicAll({Key? key,  required this.topics}) : super(key: key);
  
  @override
  State<TopicAll> createState() => _TopicAll();
}

class _TopicAll extends State<TopicAll> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Value of all topics'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: createTexttextfields()
              ),
      ]),
      
    );
  }

  createTexttextfields (){
    List<LineSeries> x = [];
    for (var i = 0; i < widget.topics.length; i++) {
      var textEditingController = LineSeries<OldValue, String>(
                    dataSource: widget.topics[i].oldValues,
                    xValueMapper: (OldValue sales, _) => sales.index.toString(),//widget.topic.oldValues.indexWhere((e) => e == sales).toString(),//getIndexGraf().toString(),//
                    yValueMapper: (OldValue sales, _) => num.parse(sales.value),
                    name: widget.topics[i].name,
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true));
      x.add(textEditingController);
    }
    return x;
}

}