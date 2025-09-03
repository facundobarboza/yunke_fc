import 'package:flutter/material.dart';
import '../widgets/sponsors_carousel.dart';
import '../widgets/next_matches_widget.dart';
import '../widgets/team_sections_widget.dart';
// import '../widgets/membership_section_widget.dart';
import '../utils/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Bienvenido',
                      style: TextStyle(
                        color: AppTheme.yunkeWhite,
                        fontSize: 16,
                      ),
                    ),
                    const Text(
                      'YUNKE FC',
                      style: TextStyle(
                        color: AppTheme.yunkeWhite,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppTheme.yunkeBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Sponsors Carousel
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 0, right: 0, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 0),
                    child: const Text(
                      'NUESTROS PATROCINADORES',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.yunkeBlue,
                      ),
                    ),
                  ),
                  SponsorsCarousel(),
                ],
              ),
            ),
            
            // Next Matches
            NextMatchesWidget(),
            
            // Team Sections
            const TeamSectionsWidget(),
            
            // Membership Section
            // const MembershipSectionWidget(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}