import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/match.dart';
import '../utils/theme.dart';
import '../services/supabase_service.dart';
import 'match_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _supabaseService = SupabaseService();
  List<Match> _matches = [];
  bool _isLoading = true;
  StreamSubscription? _matchesSubscription;

  @override
  void initState() {
    super.initState();
    _setupMatchesStream();
  }

  @override
  void dispose() {
    _matchesSubscription?.cancel();
    super.dispose();
  }

  void _setupMatchesStream() {
    _matchesSubscription = _supabaseService.getAllMatches().listen(
      (matches) {
        if (!mounted) return;
        setState(() {
          _matches = matches;
          _isLoading = false;
        });
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar los partidos: $error'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Agrupar partidos por fecha
    final groupedMatches = groupMatchesByDate(_matches);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendario',
          style: TextStyle(color: AppTheme.yunkeWhite),
        ),
        backgroundColor: AppTheme.yunkeBlue,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.yunkeBlue),
              ),
            )
          : _matches.isEmpty
          ? const Center(
              child: Text(
                'No hay partidos programados',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                if (!mounted) return;
                setState(() {
                  _isLoading = true;
                });
                // Creamos un Completer para manejar la actualización
                final completer = Completer();
                // Nos suscribimos a un solo evento del stream
                _supabaseService
                    .getAllMatches()
                    .first
                    .then((matches) {
                      if (!mounted) return;
                      setState(() {
                        _matches = matches;
                        _isLoading = false;
                      });
                      completer.complete();
                    })
                    .catchError((error) {
                      if (!mounted) return;
                      setState(() {
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error al actualizar: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      completer
                          .complete(); // Completamos incluso en caso de error
                    });
                return completer.future;
              },
              child: ListView.builder(
                itemCount: groupedMatches.length,
                itemBuilder: (context, index) {
                  final date = groupedMatches.keys.elementAt(index);
                  final dateMatches = groupedMatches[date]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DateHeader(date: date),
                      ...dateMatches.map((match) => _MatchCard(match: match)),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Map<DateTime, List<Match>> groupMatchesByDate(List<Match> matches) {
    final grouped = <DateTime, List<Match>>{};
    for (var match in matches) {
      final date = DateTime(
        match.matchDate.year,
        match.matchDate.month,
        match.matchDate.day,
      );
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(match);
    }
    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final DateTime date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[100],
      child: Text(
        isToday
            ? 'HOY'
            : DateFormat('EEEE d MMMM', 'es').format(date).toUpperCase(),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppTheme.yunkeBlue,
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final Match match;

  const _MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 6),
              _buildTeams(),
              const SizedBox(height: 6),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Text(
            match.competition.toUpperCase(),
            style: const TextStyle(
              color: AppTheme.yunkeBlue,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: match.category == 'masculino'
                ? Colors.blue[100]
                : Colors.pink[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            match.category.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color: match.category == 'masculino'
                  ? Colors.blue[900]
                  : Colors.pink[900],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTeams() {
    return Row(
      children: [
        _TeamInfo(teamName: match.homeTeam, logoUrl: match.homeLogo),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: match.homeScore != null && match.awayScore != null
                    ? AppTheme.yunkeBlue
                    : AppTheme.yunkeRedLight,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                match.homeScore != null && match.awayScore != null
                    ? '${match.homeScore} - ${match.awayScore}'
                    : DateFormat('HH:mm').format(match.matchDate),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.yunkeWhite,
                ),
              ),
            ),
            if (match.matchDate.hour == DateTime.now().hour &&
                match.matchDate.day == DateTime.now().day &&
                match.matchDate.month == DateTime.now().month &&
                match.matchDate.year == DateTime.now().year)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.yunkeRedLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'EN VIVO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        _TeamInfo(teamName: match.awayTeam, logoUrl: match.awayLogo),
      ],
    );
  }

  Widget _buildFooter() {
    return Text(
      match.venue.toUpperCase(),
      style: const TextStyle(
        color: AppTheme.yunkeBlue,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
    );
  }
}

class _TeamInfo extends StatelessWidget {
  final String teamName;
  final String? logoUrl;

  const _TeamInfo({required this.teamName, this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          if (logoUrl != null && logoUrl!.isNotEmpty)
            Image.network(
              logoUrl!,
              height: 40,
              width: 40,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.sports_soccer,
                size: 40,
                color: AppTheme.yunkeBlue,
              ),
            )
          else
            const Icon(
              Icons.sports_soccer,
              size: 35,
              color: AppTheme.yunkeBlue,
            ),
          const SizedBox(height: 8),
          Text(
            teamName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
