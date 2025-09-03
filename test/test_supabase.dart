import 'package:supabase_flutter/supabase_flutter.dart';

void testSupabaseConnection() async {
  try {
    final response = await Supabase.instance.client
        .from('sponsors')
        .select()
        .limit(1);
    
    print('✅ Supabase conectado correctamente!');
    print('📊 Datos encontrados: ${response.length}');
  } catch (e) {
    print('❌ Error conectando con Supabase: $e');
  }
}