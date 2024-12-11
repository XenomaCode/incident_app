import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:incident_app/domain/providers/ticket_provider.dart';
import 'package:incident_app/domain/entities/ticket.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
      ticketProvider.getTickets();
    });
  }

  Set<Marker> _createMarkers(List<Ticket> tickets) {
    final markers = <Marker>{};
    for (var ticket in tickets) {
      final coordenadas = ticket.location.coordinates;
      markers.add(
        Marker(
          markerId: MarkerId(ticket.id),
          position: LatLng(coordenadas[1], coordenadas[0]),
          infoWindow: InfoWindow(
            title: '${ticket.ticketNumber} - ${ticket.title}',
            snippet: '''
Descripción: ${ticket.description}
Prioridad: ${ticket.priority}
Categoría: ${ticket.category}
Sucursal: ${ticket.branch.name}
''',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(_getPriorityColor(ticket.priority)),
        ),
      );
    }
    return markers;
  }

  double _getPriorityColor(String priority) {
    switch (priority) {
      case 'HIGH':
        return BitmapDescriptor.hueRed;
      case 'MEDIUM':
        return BitmapDescriptor.hueOrange;
      default:
        return BitmapDescriptor.hueGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Tickets'),
      ),
      body: Consumer<TicketProvider>(
        builder: (context, ticketProvider, child) {
          if (ticketProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          _markers.clear();
          _markers.addAll(_createMarkers(ticketProvider.tickets));
          
          return GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(19.4326, -99.1332), // CDMX
              zoom: 11,
            ),
            markers: _markers,
          );
        },
      ),
    );
  }
}
