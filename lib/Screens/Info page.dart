import 'package:agro_analyzer_app/Model/Info.dart';
import 'package:flutter/material.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:draw_graph/models/feature.dart';


class InfoPage extends StatefulWidget {
  int index;
  InfoPage({Key? key, required this.index }): super(key: key);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

List<double> data = [];
List<String> xData = [];
List<String> yData = [];
List<double> time =[];
List<double> minData = [0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,];
List<double> optData = [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,];
late List<Feature> feature;

void get_data(){
  for(var x in sectors[widget.index]){
    print(x);
    data.add(x.moisture??0.0);
    time.add(x.time??0.0);
  }
  for(int i=0; i<=25; i+=2){
    xData.add(i.toString());
  }
  for(int u=0; u<=10; u++){
    yData.add((u/10).toString());
  }
  print(data);
}

  @override
  void initState() {
  get_data();
  feature = [Feature(
    title: "Moisture",
    color: Colors.blueAccent,
    data: data
  ),
 Feature(title: "Minimum",
        data: minData,
    color: Colors.redAccent),
    Feature(title: "Optimal",
        data: optData,
    color: Colors.green)];
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              (0.3),
              (0.2),
            ],
            colors: [
              Colors.green,
              Colors.lightBlueAccent,
            ],
          )
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("Sector ${widget.index+1}"),backgroundColor: Colors.green,),
        backgroundColor: Colors.greenAccent,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20, top: 20),
                    child: Text("Current Moisture level: ",
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 20),
                    child: Text("${(sectors[widget.index].isEmpty?0.0:sectors[widget.index].last.moisture??0.1111)*100} %",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 9.0),
                      child: LineGraph(
                        features: feature,
                        size: Size(420, 450),
                        labelX: xData,
                        labelY: yData,
                        showDescription: true,
                        graphColor: Colors.black87,
                        graphOpacity: 0.1,
                      ),
                    ),
                  ),],
            ),
          ),
      ),
    );
  }
}
