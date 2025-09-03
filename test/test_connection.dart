import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> testSupabaseConnection() async {
  try {
    // Probar conexión básica
    final response = await Supabase.instance.client
        .from('sponsors')
        .select('name')
        .limit(1);
    
    if (kDebugMode) {
      print('✅ Conexión exitosa! Datos: $response');
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ Error de conexión: $e');
    }
  }
}