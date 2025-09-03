import 'package:flutter/material.dart';
import '../models/membership_benefit.dart';
import '../services/supabase_service.dart';
import '../utils/theme.dart';

class MembershipBenefitsScreen extends StatelessWidget {
  final SupabaseService _supabaseService = SupabaseService();

  MembershipBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beneficios de Socios'),
        backgroundColor: AppTheme.yunkeBlue,
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.yunkeRed, AppTheme.yunkeRed.withOpacity(0.8)],
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.card_membership,
                  size: 60,
                  color: AppTheme.yunkeWhite,
                ),
                SizedBox(height: 12),
                Text(
                  '¡Hacete Socio del Yunke FC!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.yunkeWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Disfruta de todos estos beneficios exclusivos',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.yunkeWhite.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Lista de beneficios
          Expanded(
            child: StreamBuilder<List<MembershipBenefit>>(
              stream: _supabaseService.getMembershipBenefits(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar beneficios'));
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.card_membership,
                          size: 80,
                          color: AppTheme.yunkeGray,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay beneficios disponibles',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Agrupar por categoría
                Map<String, List<MembershipBenefit>> groupedBenefits = {};
                for (var benefit in snapshot.data!) {
                  if (!groupedBenefits.containsKey(benefit.category)) {
                    groupedBenefits[benefit.category] = [];
                  }
                  groupedBenefits[benefit.category]!.add(benefit);
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: groupedBenefits.length,
                  itemBuilder: (context, index) {
                    String category = groupedBenefits.keys.elementAt(index);
                    List<MembershipBenefit> benefits = groupedBenefits[category]!;
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (index > 0) SizedBox(height: 24),
                        
                        // Título de la categoría
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.yunkeBlue,
                          ),
                        ),
                        SizedBox(height: 12),
                        
                        // Beneficios de la categoría
                        ...benefits.map((benefit) => _buildBenefitCard(benefit)),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          
          // Botón de contacto
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 25, top: 10),
            child: ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la funcionalidad de contacto
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Contacta al club para más información sobre membresías'),
                    backgroundColor: AppTheme.yunkeBlue,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.yunkeBlue,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Contactar para Asociarse',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.yunkeWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitCard(MembershipBenefit benefit) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppTheme.yunkeRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                _getIconFromString(benefit.icon),
                color: AppTheme.yunkeRed,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    benefit.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.yunkeBlue,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    benefit.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'discount':
        return Icons.discount;
      case 'event':
        return Icons.event;
      case 'sports':
        return Icons.sports_soccer;
      case 'shopping':
        return Icons.shopping_bag;
      case 'priority':
        return Icons.priority_high;
      case 'gift':
        return Icons.card_giftcard;
      case 'parking':
        return Icons.local_parking;
      case 'restaurant':
        return Icons.restaurant;
      default:
        return Icons.star;
    }
  }
}