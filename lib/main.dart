import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/main_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  const supabaseUrl = 'https://gdnuktnbusoxyzsfokgw.supabase.co';
  const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdkbnVrdG5idXNveHl6c2Zva2d3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY2MTk5OTYsImV4cCI6MjA3MjE5NTk5Nn0.Jx-9iJkSJkFykCb0EiFj1b-S0qcpne9DonqR6cKVPy4';
  
  if (supabaseUrl.contains('YOUR_SUPABASE') || supabaseKey.contains('YOUR_SUPABASE')) {
    print('❌ ERROR: Debes configurar las credenciales de Supabase en main.dart');
    return;
  }
  
  try {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
    print('✅ Supabase inicializado correctamente');
  } catch (e) {
    print('❌ Error inicializando Supabase: $e');
    return;
  }
  
  runApp(YunkeFCApp());
}

class YunkeFCApp extends StatefulWidget {
  const YunkeFCApp({super.key});

  @override
  _YunkeFCAppState createState() => _YunkeFCAppState();
}

class _YunkeFCAppState extends State<YunkeFCApp> {
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkSupabaseConnection();
  }

  Future<void> _checkSupabaseConnection() async {
    try {
      // Probar conexión
      await Supabase.instance.client.from('sponsors').select().limit(1);
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yunke FC',
      theme: AppTheme.lightTheme,
      home: _isLoading 
          ? _LoadingScreen()
          : _error != null 
              ? _ErrorScreen(error: _error!)
              : MainScreen(),  // Cambia HomeScreen por MainScreen
      debugShowCheckedModeBanner: false,
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Cargando...'),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final String error;
  const _ErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Error de Conexión',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'No se pudo conectar. Verifica tu configuración.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Error: $error',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}