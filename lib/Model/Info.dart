List<Sensors> main_list = [];
List<List<MoistureSensors>> sectors = [];

class Sensors {
  double? humidity;
  double? moisture;
  double? temperature;
  double? time;
  double? nitrogen;
  double? phosphorous;
  double? potassium;
  double? latitide;
  double? longtitude;

  Sensors(this.humidity, this.moisture, this.nitrogen, this.phosphorous,
      this.potassium, this.temperature, this.time, this.latitide, this.longtitude);


  Sensors.fromJson(Map<String,dynamic> parsedJson):
        humidity = parsedJson["Humidity"],
        moisture = parsedJson["Moisture"],
        nitrogen = parsedJson["Nitrogen"],
        phosphorous = parsedJson["Phosphorous"],
        potassium = parsedJson["Potassium"],
        temperature = parsedJson["Temperature"],
        time = parsedJson["Time"],
        latitide = parsedJson["Latitude"],
        longtitude = parsedJson["Longitude"];
}


class MoistureSensors{
  double? moisture;
  double? time;
  MoistureSensors(this.moisture, this.time);
  MoistureSensors.fromJson(Map<String,dynamic> parsedJson):
        moisture = parsedJson["Moisture"],
        time = parsedJson["Time"];

}
