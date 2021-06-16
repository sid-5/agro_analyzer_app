import 'package:agro_analyzer_app/Model/Info.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  static final LatLng _kMapCenter =
  LatLng(18.386032, 73.915611);

  static final CameraPosition _kInitialPosition =
  CameraPosition(target: _kMapCenter, zoom: 18.0, tilt: 0, bearing: 0);

  late GoogleMapController _controller;
  Location _location = Location();

  Set<Marker> marker = {
    /*  Marker(
          markerId: MarkerId("marker_1"),
          position: _kMapCenter,
          infoWindow: InfoWindow(title: 'Marker 1'),
      onTap: (){}),
      Marker(
        markerId: MarkerId("marker_2"),
        position: LatLng(20, 72.8379758747611),
        infoWindow: InfoWindow(title: 'Marker 2'),

      ),*/
    };

  void get_marker(){
    for(var s in main_list)
    {marker.add(Marker(
        markerId: MarkerId("MarkerID ${s.time}"),
        position: LatLng(s.latitide!, s.longtitude!),
        infoWindow: InfoWindow(title: "Location ${main_list.indexOf(s)+1}", onTap: (){infoWidget(context, s, main_list.indexOf(s));}),

    ));}
    print("List fo markers is: $marker");
  }

  @override
  void initState() {
    get_marker();
    super.initState();
  }
  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Map View'),
        ),backgroundColor: Colors.transparent,
        body:Center(
          child: Column(
              children: [
                SizedBox(height: 20,),
                Container(
                  height: MediaQuery.of(context).size.height*0.6,
                  width: MediaQuery.of(context).size.width*0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: GoogleMap(
                    initialCameraPosition: _kInitialPosition,
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    buildingsEnabled: false,
                    markers: marker,
                    mapType: MapType.satellite,
                  ),

                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.symmetric(vertical: 20),child: Text("Current Readings: ",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      Text("Humidity: ${(main_list.isEmpty?0.0:(main_list.last.humidity??0.0))} %RH",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                      Text("Temperature: ${(main_list.isEmpty?0.1:(main_list.last.temperature??0.0))} °C",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                      Text("Moisture: ${(main_list.isEmpty?0.1:(main_list.last.moisture??0.0))} %",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                      Text("Nitrogen: ${(main_list.isEmpty?0.1:(main_list.last.nitrogen??0.0))} mg/kg",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                      Text("Phosphorous: ${(main_list.isEmpty?0.1:(main_list.last.phosphorous??0.0))} mg/kg",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                      Text("Potassium: ${(main_list.isEmpty?0.1:(main_list.last.potassium??0.0))} mg/kg",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                    ],
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }
  infoWidget(BuildContext context, Sensors s, int index){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(title: Text("Location ${index+1}",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
      backgroundColor: Colors.green,
      content: Container(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text("Humidity: ${(main_list.isEmpty?0.0:(main_list.last.humidity??0.0))} %RH",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("Temperature: ${(main_list.isEmpty?0.1:(main_list.last.temperature??0.0))} °C",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("Moisture: ${(main_list.isEmpty?0.1:(main_list.last.moisture??0.0))} %",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("Nitrogen: ${(main_list.isEmpty?0.1:(main_list.last.nitrogen??0.0))} mg/kg",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("Phosphorous: ${(main_list.isEmpty?0.1:(main_list.last.phosphorous??0.0))} mg/kg",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("Potassium: ${(main_list.isEmpty?0.1:(main_list.last.potassium??0.0))} mg/kg",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("Location: ${(s.longtitude??0.0)}N ${(s.longtitude??0.0)}S",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
            Text("Comments: ")
            ],
        ),
      ),actions: [
        ElevatedButton(onPressed: (){Navigator.of(context).pop();},
        child: Text("Ok"),)
        ],);});
  }
}

