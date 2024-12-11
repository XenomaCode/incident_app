import 'package:flutter/material.dart';
import 'package:incident_app/domain/datasources/incident_datasource.dart';
import 'package:incident_app/domain/entities/incident.dart';

class IncidentProvider extends ChangeNotifier {
  final IncidentDatasource _incidentDatasource;

  IncidentProvider(this._incidentDatasource);
  final List<Incident> incidents = [];
  int trafficCount = 0;
  int theftCount = 0;
  bool isLoading = false;

  Future<List<Incident>> getIncidents() async {
    isLoading = true;
    notifyListeners();
    try {
      final fetchedIncidents = await _incidentDatasource.getIncidents();
      incidents.clear();
      incidents.addAll(fetchedIncidents);
      theftCount = incidents
          .where(
            (element) => element.type == "Robos",
          )
          .length;
      trafficCount = incidents
          .where(
            (element) => element.type == "Trafico",
          )
          .length;
      notifyListeners();
      return incidents;
    } catch (e) {
      print(e);
      return [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future addIncident(Incident incident) async {
    try {
      final newIncident = await _incidentDatasource.addIncident(incident);
      newIncident!.address = await _incidentDatasource.getAddressFromLatLng(
          newIncident.lat, newIncident.lng);
      incidents.add(newIncident);
      theftCount = incidents
          .where(
            (element) => element.type == "Robos",
          )
          .length;
      trafficCount = incidents
          .where(
            (element) => element.type == "Trafico",
          )
          .length;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
