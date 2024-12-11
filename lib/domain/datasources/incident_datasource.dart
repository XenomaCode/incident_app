import 'package:dio/dio.dart';
import 'package:incident_app/config/constants.dart';
import 'package:incident_app/domain/entities/incident.dart';

class IncidentDatasource {

  final incidentClient = Dio(BaseOptions(
    baseUrl: Constants.baseApiUrl
  ));

Future<List<Incident>> getIncidents() async {
  final response = await incidentClient.get("/incidents");
  final incidentsData = response.data as List;
  print(incidentsData);
  final incidentList = incidentsData.map((item) => Incident.fromJson(item)).toList();

  /* for (var incident in incidentList){
    incident.address = await getAddressFromLatLng(incident.lat, incident.lng);
  } */
  return incidentList;
}

Future<String?> getAddressFromLatLng(double lat, double lng) async {
  Dio client = Dio();
  try {
    final response = await client.get(Constants.mapsGeoCodeUrl, queryParameters: {
      "latlng": "$lat,$lng",
      "key": Constants.mapsApiKey
    });
    if(response.statusCode == 200){
      final data = response.data;
      if(data["status"] == "OK"){
        final results = data["results"];
        final address = results[0]["formatted_address"];
        return address;
      }
    }
    return "";
  }
  catch(e){
    print(e);
    return "";
  }
    
  }

  Future<Incident?> addIncident(Incident incident) async {
    try {
      final response = await incidentClient.post("/incidents", data: {
        "title": incident.title,
        "description": incident.description,
        "lat": incident.lat,
        "lng": incident.lng,
        "isEmailSent": incident.isEmailSent,
        "type": incident.type
      });
      return Incident.fromJson(response.data);
      
    } catch (e) {
      print(e);
      return null;      
    }

  }


}