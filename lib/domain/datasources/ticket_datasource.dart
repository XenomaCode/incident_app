import 'package:dio/dio.dart';
import 'package:incident_app/domain/entities/ticket.dart';
import 'package:incident_app/config/constants.dart';


class TicketDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Constants.baseApiUrl,
  ));

  Future<List<Ticket>> getTickets() async {
    try {
      final response = await dio.get('/tickets/');
      return (response.data as List)
          .map((ticket) => Ticket.fromJson(ticket))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Ticket?> createTicket(Map<String, dynamic> ticketData) async {
    try {
      final response = await dio.post('/tickets/', data: ticketData);
      return Ticket.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> deleteTicket(String id) async {
    try {
      await dio.delete('/tickets/$id');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Ticket?> updateTicket(String id, Map<String, dynamic> ticketData) async {
    try {
      final response = await dio.put('/tickets/$id', data: ticketData);
      return Ticket.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
} 