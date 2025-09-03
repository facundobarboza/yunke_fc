class Match {
  final String id;
  final String homeTeam;
  final String? homeLogo;
  final String? homeScore;
  final String awayTeam;
  final String? awayLogo;
  final String? awayScore;
  final DateTime matchDate;
  final String venue;
  final String category; // 'masculino' o 'femenino'
  final String status; // 'scheduled', 'live', 'finished'
  final String competition;

  Match({
    required this.id,
    required this.homeTeam,
    this.homeLogo,
    this.homeScore,
    required this.awayTeam,
    this.awayLogo,
    this.awayScore,
    required this.matchDate,
    required this.venue,
    required this.category,
    required this.status,
    required this.competition,
  });

  factory Match.fromMap(Map<String, dynamic> map) {
    return Match(
      id: map['id']?.toString() ?? '',
      homeTeam: map['home_team'] ?? '',
      homeLogo: map['home_logo'] ?? '',
      homeScore: map['home_score']?.toString(),
      awayTeam: map['away_team'] ?? '',
      awayLogo: map['away_logo'] ?? '',
      awayScore: map['away_score']?.toString(),
      matchDate: DateTime.parse(map['match_date']),
      venue: map['venue'] ?? '',
      category: map['category'] ?? '',
      status: map['status'] ?? 'scheduled',
      competition: map['competition'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'home_team': homeTeam,
      'home_score': homeScore,
      'home_logo': homeLogo,
      'away_team': awayTeam,
      'away_logo': awayLogo,
      'away_score': awayScore,
      'match_date': matchDate.toIso8601String(),
      'venue': venue,
      'category': category,
      'status': status,
      'competition': competition,
    };
  }
}