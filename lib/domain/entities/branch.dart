class Branch {
  final String id;
  final String name;
  final String code;
  final Map<String, dynamic> location;
  final String address;
  final String phone;
  final String email;
  final bool isActive;

  Branch({
    required this.id,
    required this.name,
    required this.code,
    required this.location,
    required this.address,
    required this.phone,
    required this.email,
    this.isActive = true,
  });

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      location: json['location'] ?? {'type': 'Point', 'coordinates': [0, 0]},
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }
} 