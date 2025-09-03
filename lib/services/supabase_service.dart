import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import '../models/sponsor.dart';
import '../models/match.dart';
import '../models/player.dart';
import '../models/membership_benefit.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Sponsors
  Stream<List<Sponsor>> getSponsors() {
    return _supabase
        .from('sponsors')
        .stream(primaryKey: ['id'])
        .map((data) => data.map((json) => Sponsor.fromMap(json)).toList());
  }

  Future<Sponsor> getSponsorById(String id) async {
    final data = await _supabase
        .from('sponsors')
        .select()
        .eq('id', id)
        .single();
    return Sponsor.fromMap(data);
  }

  // Matches
  Stream<List<Match>> getAllMatches() {
    return _supabase
        .from('matches')
        .stream(primaryKey: ['id'])
        .order('match_date')
        .map((data) => data.map((json) => Match.fromMap(json)).toList());
  }

  Stream<List<Match>> getUpcomingMatches() {
    final now = DateTime.now();
    return _supabase
        .from('matches')
        .stream(primaryKey: ['id'])
        .eq('status', 'scheduled')
        .order('match_date')
        .map((data) => data
            .where((match) => DateTime.parse(match['match_date']).isAfter(now))
            .map((json) => Match.fromMap(json))
            .toList());
  }

  Stream<List<Match>> getMatchesByCategory(String category) {
    return _supabase
        .from('matches')
        .stream(primaryKey: ['id'])
        .eq('category', category)
        .order('match_date')
        .map((data) => data.map((json) => Match.fromMap(json)).toList());
  }

  // Players
  Stream<List<Player>> getPlayersByCategory(String category) {
    return _supabase
        .from('players')
        .stream(primaryKey: ['id'])
        .eq('category', category)
        .order('number', ascending: true)
        .map((data) => data.map((json) => Player.fromMap(json)).toList());
  }

  // Membership Benefits
  Stream<List<MembershipBenefit>> getMembershipBenefits() {
    return _supabase
        .from('membership_benefits')
        .stream(primaryKey: ['id'])
        .map((data) => data.map((json) => MembershipBenefit.fromMap(json)).toList());
  }

  // Storage helpers
  String getPublicUrl(String bucket, String path) {
    return _supabase.storage.from(bucket).getPublicUrl(path);
  }

  Future<String> uploadFile(String bucket, String path, Uint8List fileBytes) async {
    await _supabase.storage.from(bucket).uploadBinary(path, fileBytes);
    return getPublicUrl(bucket, path);
  }

  // Método alternativo para subir archivos desde List<int>
  Future<String> uploadFileFromBytes(String bucket, String path, List<int> fileBytes) async {
    final uint8List = Uint8List.fromList(fileBytes);
    await _supabase.storage.from(bucket).uploadBinary(path, uint8List);
    return getPublicUrl(bucket, path);
  }
}