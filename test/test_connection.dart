import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> testSupabaseConnection() async {
  try {
    // Probar conexión básica
    final response = await Supabase.instance.client
        .from('sponsors')
        .select('name')
        .limit(1);
    
    print('✅ Conexión exitosa! Datos: $response');
  } catch (e) {
    print('❌ Error de conexión: $e');
  }
}