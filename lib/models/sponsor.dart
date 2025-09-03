class Sponsor {
  final String id;
  final String name;
  final String logo;
  final String description;
  final String website;
  final String phone;
  final String email;
  final String address;
  final List<String> services;

  Sponsor({
    required this.id,
    required this.name,
    required this.logo,
    required this.description,
    required this.website,
    required this.phone,
    required this.email,
    required this.address,
    required this.services,
  });

  factory Sponsor.fromMap(Map<String, dynamic> map) {
    return Sponsor(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      logo: map['logo'] ?? '',
      description: map['description'] ?? '',
      website: map['website'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      services: List<String>.from(map['services'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'description': description,
      'website': website,
      'phone': phone,
      'email': email,
      'address': address,
      'services': services,
    };
  }
}