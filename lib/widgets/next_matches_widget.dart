import 'package:flutter/material.dart';
import '../models/match.dart';
import '../services/supabase_service.dart';
import '../screens/match_detail_screen.dart';
import '../utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class NextMatchesWidget extends StatelessWidget {
  final SupabaseService _supabaseService = SupabaseService();

  NextMatchesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRÓXIMOS PARTIDOS',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.yunkeBlue
            ),
          ),
          SizedBox(height: 12),
          StreamBuilder<List<Match>>(
            stream: _supabaseService.getUpcomingMatches(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SizedBox(
                  height: 100,
                  child: Center(child: Text('Error al cargar partidos')),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              // Separar por categorías
              final maleMatches = snapshot.data!
                  .where((match) => match.category == 'masculino')
                  .take(1)
                  .toList();
              final femaleMatches = snapshot.data!
                  .where((match) => match.category == 'femenino')
                  .take(1)
                  .toList();

              return Column(
                children: [
                  if (maleMatches.isNotEmpty)
                    _buildMatchCard(context, maleMatches.first),
                  SizedBox(height: 12),
                  if (femaleMatches.isNotEmpty)
                    _buildMatchCard(context, femaleMatches.first),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, Match match) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchDetailScreen(match: match),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "${match.competition.toUpperCase()} - ${match.category.toUpperCase()}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            match.homeTeam,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ),
                        Image.network(
                          match.homeLogo ?? '',
                          width: 45,
                          height: 45,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.sports_soccer, size: 45);
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.yunkeRed,
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Text(
                      DateFormat('HH:mm').format(match.matchDate),
                      style: TextStyle(
                        color: AppTheme.yunkeWhite,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.network(
                          match.awayLogo ?? '',
                          width: 45,
                          height: 45,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.sports_soccer, size: 45);
                          },
                        ),
                        Flexible(
                          child: Text(
                            match.awayTeam,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  _formatDateNextMatch(match.matchDate).toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _formatDateNextMatch(DateTime date) {
    try {
      initializeDateFormatting('es');
      return DateFormat('EEEE, dd MMMM', 'es').format(date);
    } catch (e) {
      // Si falla, usar formato básico en inglés
      return DateFormat('EEEE, dd MMMM').format(date);
    }
  }
}