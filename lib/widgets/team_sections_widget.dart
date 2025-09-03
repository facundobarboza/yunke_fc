import 'package:flutter/material.dart';
import '../screens/team_screen.dart';
import '../utils/theme.dart';

class TeamSectionsWidget extends StatelessWidget {
  const TeamSectionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NUESTROS EQUIPOS',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppTheme.yunkeBlue,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildTeamCard(
                  context,
                  'Equipo Masculino',
                  'masculino',
                  Icons.people,
                  AppTheme.yunkeBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTeamCard(
                  context,
                  'Equipo Femenino',
                  'femenino',
                  Icons.people,
                  AppTheme.yunkeRed,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(
    BuildContext context,
    String title,
    String category,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamScreen(category: category),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: AppTheme.yunkeWhite,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.yunkeWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Ver Plantel',
                style: TextStyle(
                  color: AppTheme.yunkeWhite.withValues(alpha: 0.9),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}