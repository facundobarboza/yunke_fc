class MembershipBenefit {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;

  MembershipBenefit({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
  });

  factory MembershipBenefit.fromMap(Map<String, dynamic> map) {
    return MembershipBenefit(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      category: map['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'category': category,
    };
  }
}