import 'dart:convert';
import 'package:agro_analyzer_app/Screens/MapPage.dart';
import 'package:expandable/expandable.dart';
import 'package:agro_analyzer_app/Model/Info.dart';
import 'package:agro_analyzer_app/Screens/Info%20page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

List<MoistureSensors> list =[MoistureSensors(0.2, 1),MoistureSensors(0.6, 1),MoistureSensors(0.3, 1),MoistureSensors(0.2, 1),MoistureSensors(0.5, 1),MoistureSensors(0.4, 1),MoistureSensors(0.4, 1)];
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{


  Future<String> getJsonFromFirebaseRestAPI() async {
    String url = "API address";
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  Future loadData() async {
    String jsonString = await getJsonFromFirebaseRestAPI();
    final jsonResponse = json.decode(jsonString);
    print(jsonResponse);
    for (var i in jsonResponse["Main"]){
      if(i!=null)
        main_list.add(Sensors.fromJson(i));
    }
    for(int i=1; i<=6; i++){
      List<MoistureSensors> temp = [];
      for (var j in jsonResponse["Sector$i"]){
        if(j!=null) {
          print(j);
          temp.add(MoistureSensors.fromJson(j));
        }
      }
      sectors.add(temp);
      print("Sector$i");
    }
    setState(() {
  });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top+10))
          ,Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Agro Analyzers",style: TextStyle(fontSize: 28,letterSpacing:2,fontWeight: FontWeight.bold,color: Colors.green),),
                IconButton(onPressed: (){
                  Navigator.pushNamed(context, 'second');
                },
                    icon: Icon(Icons.settings,size: 30,))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:20.0, left: 20, right: 20),
            child: GestureDetector(
              onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()),
    );},
              child: ExpandableNotifier(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [
                                ((main_list.isEmpty?0.1:(main_list.last.moisture??0.2))-0.3),
                                ((main_list.isEmpty?0.1:(main_list.last.moisture??0.2))+0.2),
                              ],
                              colors: [
                                Colors.green,
                                Colors.lightBlueAccent,
                              ],
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: Column(
                            children: <Widget>[
                              ScrollOnExpand(
                                scrollOnExpand: true,
                                scrollOnCollapse: false,
                                child: ExpandablePanel(
                                  theme: const ExpandableThemeData(
                                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                                    tapBodyToExpand: false,
                                    tapHeaderToExpand: false,
                                  ),
                                  header: Padding(
                                    padding: EdgeInsets.only(top: 15, left: 10),
                                    child: Text(
                                        "Main Unit",style: TextStyle(fontSize: 20,letterSpacing:1,fontWeight: FontWeight.bold,color: Colors.black)
                                    ),
                                  ),
                                  collapsed:Text(
                                    'Condition: well',
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                  ),
                                  expanded: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Humidity: ${(main_list.isEmpty?0.0:(main_list.last.humidity??0.0))} %RH",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                      Text("Temperature: ${(main_list.isEmpty?0.1:(main_list.last.temperature??0.0))} °C",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                      Text("Moisture: ${(main_list.isEmpty?0.1:(main_list.last.moisture??0.0))*100} %",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                      Text("Nitrogen: ${(main_list.isEmpty?0.1:(main_list.last.nitrogen??0.0))} mg/kg",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                      Text("Phosphorous: ${(main_list.isEmpty?0.1:(main_list.last.phosphorous??0.0))} mg/kg",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                      Text("Potassium: ${(main_list.isEmpty?0.1:(main_list.last.potassium??0.0))} mg/kg",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                  builder: (_, collapsed, expanded) {
                                    return Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Expandable(
                                        collapsed: collapsed,
                                        expanded: expanded,

                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                });
              },
              child:StaggeredGridView.countBuilder(crossAxisCount: 2,
                    padding: EdgeInsets.all(20),
                    itemCount: sectors.length,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 2,
                    itemBuilder: (context, index){

                      return GestureDetector(
                            onTap: (){Navigator.of(context).push(
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) {
                                  return InfoPage(index: index);
                                },
                                transitionsBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child) {
                                  return Align(
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  );
                                },
                              ),
                            );},
                            child: ExpandableNotifier(
                                child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [
                                              ((sectors[index].last.moisture??0.1)-0.3),
                                              ((sectors[index].last.moisture??0.1)+0.2),
                                            ],
                                            colors: [
                                              Colors.green,
                                              (sectors.isEmpty?0.2:(sectors[index].last.moisture??0.2))>0.1?Colors.lightBlueAccent:Colors.redAccent,
                                            ],
                                          )
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 50.0),
                                        child: Column(
                                          children: <Widget>[
                                            ScrollOnExpand(
                                              scrollOnExpand: true,
                                              scrollOnCollapse: false,
                                              child: ExpandablePanel(
                                                theme: const ExpandableThemeData(
                                                  tapBodyToExpand: false,
                                                  tapHeaderToExpand: false,
                                                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                                                  tapBodyToCollapse: true,
                                                ),
                                                header: Padding(
                                                    padding: EdgeInsets.only(top: 15, left: 10),
                                                    child: Text(
                                                        "Sector ${index+1}",style: TextStyle(fontSize: 20,letterSpacing:1,fontWeight: FontWeight.bold,color: Colors.black)
                                                      ),
                                                    ),
                                                collapsed:Text(
                                                    'Condition: well',
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                                  ),
                                                expanded: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[

                                                    Text("Moisture: ",
                                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                                    Text("${(sectors[index].isEmpty?0.0:sectors[index].last.moisture??0.1111)*100} %",
                                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                                                  ],
                                                ),
                                                builder: (_, collapsed, expanded) {
                                                  return Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Expandable(
                                                      collapsed: collapsed,
                                                      expanded: expanded,

                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          );
                    },
                    staggeredTileBuilder: (index)=> StaggeredTile.fit(1)),
              ),
          ),
          
        ],
      ),
    );
  }
}

