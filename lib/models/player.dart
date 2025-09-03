class Player {
  final String id;
  final String name;
  final String position;
  final int number;
  final String photo;
  final String category; // 'masculino' o 'femenino'
  final String nationality;
  final DateTime birthdate;

  Player({
    required this.id,
    required this.name,
    required this.position,
    required this.number,
    required this.photo,
    required this.category,
    required this.nationality,
    required this.birthdate,
  });

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      position: map['position'] ?? '',
      number: map['number'] ?? 0,
      photo: map['photo'] ?? '',
      category: map['category'] ?? '',
      nationality: map['nationality'] ?? '',
      birthdate: DateTime.parse(map['birthdate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position,
      'number': number,
      'photo': photo,
      'category': category,
      'nationality': nationality,
      'birthdate': birthdate.toIso8601String(),
    };
  }
}