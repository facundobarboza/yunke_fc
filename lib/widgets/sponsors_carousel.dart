import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/sponsor.dart';
import '../services/supabase_service.dart';
import '../screens/sponsor_detail_screen.dart';
import '../utils/theme.dart';

class SponsorsCarousel extends StatelessWidget {
  final SupabaseService _supabaseService = SupabaseService();

  SponsorsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Sponsor>>(
      stream: _supabaseService.getSponsors(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SizedBox(
            height: 150,
            child: Center(child: Text('Error al cargar sponsors')),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox(
            height: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return CarouselSlider(
          options: CarouselOptions(
            height: 160,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 5),
            viewportFraction: 0.9,
          ),
          items: snapshot.data!.map((sponsor) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SponsorDetailScreen(sponsor: sponsor),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: AppTheme.yunkeWhite,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: Offset(1, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Stack(
                        children: [
                          Center(
                            child: CachedNetworkImage(
                              imageUrl: sponsor.logo,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.image,
                                size: 50,
                                color: AppTheme.yunkeBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}