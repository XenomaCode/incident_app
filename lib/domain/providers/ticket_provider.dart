import 'package:flutter/material.dart';
import 'package:incident_app/domain/entities/ticket.dart';
import 'package:incident_app/domain/datasources/ticket_datasource.dart';


class TicketProvider extends ChangeNotifier {
  final _ticketDatasource = TicketDatasource();
  List<Ticket> tickets = [];
  bool isLoading = false;
  String errorMessage = '';

  int get itSupportCount => tickets.where((t) => t.category == 'IT_SUPPORT').length;
  int get highPriorityCount => tickets.where((t) => t.priority == 'HIGH').length;

  Future<void> getTickets() async {
    try {
      if (isLoading) return; // Evitar múltiples llamadas simultáneas
      
      isLoading = true;
      errorMessage = '';
      notifyListeners();
      
      final ticketsResponse = await _ticketDatasource.getTickets();
      
      if (ticketsResponse != null) {
        tickets = ticketsResponse;
        print('Se cargaron ${tickets.length} tickets exitosamente');
      } else {
        errorMessage = 'No se pudieron cargar los tickets';
        print('Error: La respuesta del servidor fue nula');
      }

    } catch (e) {
      errorMessage = 'Error al cargar los tickets: $e';
      print('Error al obtener tickets: $e');
      tickets = []; // Limpiar tickets en caso de error
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTicket(Map<String, dynamic> ticketData) async {
    try {
      // Imprimir datos recibidos
      print('Datos recibidos para crear ticket:');
      print('-------------------------');
      print('Title: ${ticketData['title']}');
      print('Description: ${ticketData['description']}');
      print('Branch ID: ${ticketData['branch']}');
      print('Category: ${ticketData['category']}');
      print('Priority: ${ticketData['priority']}');
      print('Created By (User ID): ${ticketData['createdBy']}');
      print('Location: ${ticketData['location']}');
      print('-------------------------');

      final formattedData = {
        'title': ticketData['title'],
        'description': ticketData['description'],
        'branch': ticketData['branch'],
        'category': ticketData['category'],
        'priority': ticketData['priority'],
        'createdBy': ticketData['createdBy'],
        'location': ticketData['location']
      };

      print('Datos formateados enviados al servidor:');
      print(formattedData);
      print('-------------------------');

      final ticket = await _ticketDatasource.createTicket(formattedData);
      if (ticket != null) {
        tickets.add(ticket);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error creating ticket: $e');
      return false;
    }
  }

  Future<bool> deleteTicket(String id) async {
    try {
      final success = await _ticketDatasource.deleteTicket(id);
      if (success) {
        tickets.removeWhere((ticket) => ticket.id == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateTicket(String id, Map<String, dynamic> ticketData) async {
    try {
      final updatedTicket = await _ticketDatasource.updateTicket(id, ticketData);
      
      if (updatedTicket != null) {
        final index = tickets.indexWhere((ticket) => ticket.id == id);
        if (index != -1) {
          tickets[index] = updatedTicket;
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
} 