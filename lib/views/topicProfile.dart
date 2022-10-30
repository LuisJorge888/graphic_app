import 'dart:ui';

import 'package:bussines/models/topic.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class TopicProfile extends StatefulWidget {
  Topic topic;

  TopicProfile({Key? key, required this.topic}) : super(key: key);

  @override
  State<TopicProfile> createState() => _TopicProfile();
}

class _TopicProfile extends State<TopicProfile> {
  //late List<Topic> data;
  int index = 0;
  num maxValue = 1;
  num minValue = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Wrap(children: [
          Padding(padding: EdgeInsets.only(top: 10),
          child: Row(
            children: [
              Expanded(
                  child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Value of ',
                  style: const TextStyle(
                    color: Colors.black,  fontSize: 20
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: '${widget.topic.name} - ${widget.topic.value}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
            ],
          ),
          ),
          
          
           const Divider(
              color: Colors.black
          ),
          Column(children: [
            //Initialize the chart widget
            SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart titlerr
              /*title: ChartTitle(
                  text:
                      'Value of ${widget.topic.name} - ${widget.topic.value}'),*/
              // Enable legend
              legend: Legend(isVisible: false),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<OldValue, String>>[
                LineSeries<OldValue, String>(
                    dataSource: widget.topic.getValues(),
                    xValueMapper: (OldValue sales, _) => sales.index
                        .toString(), //widget.topic.oldValues.indexWhere((e) => e == sales).toString(),//getIndexGraf().toString(),//
                    yValueMapper: (OldValue sales, _) => num.parse(sales.value),
                    name: widget.topic.name,
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true)),
              ],
            ),
          ]),
          /*const Divider(
              color: Colors.black
          ),*/
          Row(
            children: [
              Expanded(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Max ',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(
                          text: '${widget.topic.maxValue}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Min ',
                  style: const TextStyle(
                    color: Colors.black,  fontSize: 15
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: '${widget.topic.minValue}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              )),
              
            ],
          ),
        ]));
  }
}
