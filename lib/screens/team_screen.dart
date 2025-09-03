import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/player.dart';
import '../services/supabase_service.dart';
import '../utils/theme.dart';

class TeamScreen extends StatelessWidget {
  final String category;
  final SupabaseService _supabaseService = SupabaseService();

  TeamScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Equipo $category'),
        backgroundColor: AppTheme.yunkeBlue,
      ),
      body: StreamBuilder<List<Player>>(
        stream: _supabaseService.getPlayersByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar jugadores'));
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
                    Icons.sports_soccer,
                    size: 80,
                    color: AppTheme.yunkeGray,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay jugadores disponibles',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final player = snapshot.data![index];
              return _buildPlayerCard(player);
            },
          );
        },
      ),
    );
  }

  Widget _buildPlayerCard(Player player) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        children: [
          // Imagen del jugador como fondo
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppTheme.yunkeGray.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: player.photo,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yunkeBlue),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppTheme.yunkeGray.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.person,
                    size: 170,
                    color: player.category == 'masculino' 
                        ? AppTheme.yunkeBlue 
                        : AppTheme.yunkeRed,
                  ),
                ),
              ),
            ),
          ),
          
          // Gradiente superior para el número
          /* Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    player.category == 'masculino' 
                        ? AppTheme.yunkeBlue 
                        : AppTheme.yunkeRed,
                    Colors.transparent,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '#${player.number}',
                  style: const TextStyle(
                    color: AppTheme.yunkeWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ), */
          
          // Gradiente inferior para la información
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
                gradient: LinearGradient(
                  stops: const [0.3, 1.0],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors:
                    player.category == 'masculino'
                        ? [AppTheme.yunkeBlue.withValues(alpha: 0.9),
                        AppTheme.yunkeBlue.withValues(alpha: 0.1)]
                        : [AppTheme.yunkeRed.withValues(alpha: 0.9),
                        AppTheme.yunkeRed.withValues(alpha: 0.1)],
                ),
              ),
              padding: const EdgeInsets.only(left: 12, right: 12, top: 5, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.yunkeWhite,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.yunkeWhite.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          player.position.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.yunkeWhite,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}