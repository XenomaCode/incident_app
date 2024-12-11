import 'package:flutter/foundation.dart';

class Incident {
  final String id;
 final String title;
 final String description;
 final double lat;
 final double lng;
 final bool isEmailSent;
 final String type;
 String? address;

 Incident({
  required this.id,
  required this.title,
  required this.description,
   required this.lat,
   required this.lng,
   required this.isEmailSent,
   required this.type,
   this.address
 });


 factory Incident.fromJson(Map<String,dynamic> json){
  return Incident(
    id: json["_id"] as String, 
    title: json["title"] as String, 
    description: json["description"] as String, 
    lat: json["lat"] as double, 
    lng: json["lng"] as double, 
    isEmailSent: json["isEmailSent"] as bool, 
    type: json["type"] as String);
 }
}