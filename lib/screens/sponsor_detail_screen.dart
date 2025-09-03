import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/sponsor.dart';
import '../utils/theme.dart';

class SponsorDetailScreen extends StatelessWidget {
  final Sponsor sponsor;

  const SponsorDetailScreen({super.key, required this.sponsor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Patrocinador"),
        backgroundColor: AppTheme.yunkeBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo del sponsor
            Container(
              height: 200,
              width: double.infinity,
              color: AppTheme.yunkeGray,
              child: CachedNetworkImage(
                imageUrl: sponsor.logo,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(
                    Icons.business,
                    size: 80,
                    color: AppTheme.yunkeBlue,
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del sponsor
                  Text(
                    sponsor.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.yunkeBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Descripción
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sponsor.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Servicios
                  if (sponsor.services.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Productos y servicios',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.yunkeBlue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...sponsor.services.map((service) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.yunkeRed,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  service,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  const SizedBox(height: 16),
                  
                  // Contacto
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información de contacto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.yunkeBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Teléfono
                      if (sponsor.phone.isNotEmpty)
                        _buildContactItem(
                          Icons.phone,
                          'Teléfono',
                          sponsor.phone,
                          () => _launchUrl('tel:${sponsor.phone}'),
                        ),
                      
                      // Email
                      if (sponsor.email.isNotEmpty)
                        _buildContactItem(
                          Icons.email,
                          'Correo electrónico',
                          sponsor.email,
                          () => _launchUrl('mailto:${sponsor.email}'),
                        ),
                      
                      // Dirección
                      if (sponsor.address.isNotEmpty)
                        _buildContactItem(
                          Icons.location_on,
                          'Dirección',
                          sponsor.address,
                          null,
                        ),
                      
                      // Website
                      if (sponsor.website.isNotEmpty)
                        _buildContactItem(
                          Icons.language,
                          'Sitio web',
                          sponsor.website,
                          () => _launchUrl(sponsor.website),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.yunkeRed,
              size: 24,
            ),
            const SizedBox(width: 12),
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
                      color: onTap != null ? AppTheme.yunkeBlue : Colors.black,
                      decoration: onTap != null ? TextDecoration.underline : null,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.yunkeBlue,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}