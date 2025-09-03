import 'package:flutter/material.dart';
import '../screens/membership_benefits_screen.dart';
import '../utils/theme.dart';

class MembershipSectionWidget extends StatelessWidget {
  const MembershipSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MembershipBenefitsScreen(),
            ),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.yunkeBlue,
                  AppTheme.yunkeBlue,
                  AppTheme.yunkeBlue,
                  AppTheme.yunkeRed.withAlpha(200),
                  AppTheme.yunkeRed.withAlpha(200),
                ],
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '¡Hacete Socio!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.yunkeWhite,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Descubre todos los beneficios exclusivos para socios del Yunke FC',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.yunkeWhite.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.yunkeWhite,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Ver Beneficios',
                          style: TextStyle(
                            color: AppTheme.yunkeRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.card_membership,
                  size: 60,
                  color: AppTheme.yunkeWhite.withOpacity(0.8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}