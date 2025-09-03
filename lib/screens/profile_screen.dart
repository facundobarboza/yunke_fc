import 'package:flutter/material.dart';
import '../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Perfil',
        style: TextStyle(
          fontSize: 24,
          color: AppTheme.yunkeBlue,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}