import 'package:incident_app/domain/entities/user.dart';

class Ticket {
  final String id;
  final String ticketNumber;
  final Branch branch;
  final User createdBy;
  final String category;
  final String priority;
  final String status;
  final String title;
  final String description;
  final Location location;
  final DateTime createdAt;

  Ticket({
    required this.id,
    required this.ticketNumber,
    required this.branch,
    required this.createdBy,
    required this.category,
    required this.priority,
    required this.status,
    required this.title,
    required this.description,
    required this.location,
    required this.createdAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'],
      ticketNumber: json['ticketNumber'],
      branch: Branch.fromJson(json['branch']),
      createdBy: User.fromJson(json['createdBy']),
      category: json['category'],
      priority: json['priority'],
      status: json['status'],
      title: json['title'],
      description: json['description'],
      location: Location.fromJson(json['location']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Branch {
  final String id;
  final String name;
  final String code;

  Branch({required this.id, required this.name, required this.code});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'],
      name: json['name'],
      code: json['code'],
    );
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({required this.type, required this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'],
      coordinates: List<double>.from(json['coordinates']),
    );
  }
} 