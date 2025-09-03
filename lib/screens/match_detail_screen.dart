import 'package:flutter/material.dart';
import '../models/match.dart';
import '../utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MatchDetailScreen extends StatefulWidget {
  final Match match;

  const MatchDetailScreen({super.key, required this.match});

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  bool _isLocaleInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    try {
      await initializeDateFormatting('es', null);
      setState(() {
        _isLocaleInitialized = true;
      });
    } catch (e) {
      print('Error inicializando locale: $e');
      // Si falla, usar formateo básico
      setState(() {
        _isLocaleInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocaleInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Detalles del partido'),
          backgroundColor: AppTheme.yunkeBlue,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del partido'),
        backgroundColor: AppTheme.yunkeBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header del partido
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.yunkeBlue, AppTheme.yunkeBlue.withOpacity(0.8)],
                ),
              ),
              child: Column(
                children: [
                  // Categoría
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.yunkeRed,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.match.category.toUpperCase(),
                      style: TextStyle(
                        color: AppTheme.yunkeWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Equipos y resultado
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppTheme.yunkeWhite,
                                shape: BoxShape.circle,
                              ),
                              child: 
                              Center(
                                child: 
                                Image.network(
                                  widget.match.homeLogo ?? '',
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.sports_soccer, size: 45);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.match.homeTeam,
                              style: TextStyle(
                                color: AppTheme.yunkeWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      
                      // Marcador o VS
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.yunkeWhite,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: widget.match.status == 'finished' && widget.match.homeScore != null
                          ? Text(
                              '${widget.match.homeScore} - ${widget.match.awayScore}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.yunkeBlue,
                              ),
                            )
                          : Text(
                              'VS',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.yunkeBlue,
                              ),
                            ),
                      ),
                      
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppTheme.yunkeWhite,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Image.network(
                                  widget.match.awayLogo ?? '',
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.sports_soccer, size: 45);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              widget.match.awayTeam,
                              style: TextStyle(
                                color: AppTheme.yunkeWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Estado del partido
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(widget.match.status),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getStatusText(widget.match.status),
                      style: TextStyle(
                        color: AppTheme.yunkeWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Información del partido
                  Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'INFORMACIÓN DEL PARTIDO',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.yunkeBlue,
                            ),
                          ),
                          SizedBox(height: 12),
                          
                          _buildInfoRow(
                            Icons.calendar_today,
                            'Fecha y Hora',
                            _formatDate(widget.match.matchDate),
                          ),
                          
                          _buildInfoRow(
                            Icons.location_on,
                            'Estadio',
                            widget.match.venue,
                          ),
                          
                          _buildInfoRow(
                            Icons.emoji_events,
                            'Competición',
                            widget.match.competition,
                          ),
                        ],
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.yunkeRed,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'live':
        return Colors.green;
      case 'finished':
        return Colors.grey;
      case 'scheduled':
      default:
        return AppTheme.yunkeRed;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'live':
        return 'EN VIVO';
      case 'finished':
        return 'FINALIZADO';
      case 'scheduled':
      default:
        return 'PROGRAMADO';
    }
  }

  String _formatDate(DateTime date) {
    try {
      // Intentar con locale español
      return DateFormat('EEEE, dd MMMM yyyy - HH:mm', 'es').format(date);
    } catch (e) {
      // Si falla, usar formato básico
      return DateFormat('dd/MM/yyyy - HH:mm').format(date);
    }
  }
}