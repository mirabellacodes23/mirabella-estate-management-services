// ===============================
// File: lib/screens/home/why_us_section.dart
// "Why Choose Mirabella" feature grid (8 items) — responsive & overflow-proof
// ===============================
import 'package:flutter/material.dart';

import '../../constants/tokens.dart';
import '../../data/data.dart';

class WhyUsSection extends StatelessWidget {
  const WhyUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;

    // Prevent extreme accessibility scaling from breaking layouts
    final clamped = mq.copyWith(
      textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2),
    );

    final icons = <IconData>[
      Icons.shield_rounded, // Licensed & Insured
      Icons.schedule_rounded, // 24/7 Availability
      Icons.trending_up_rounded, // Maximize ROI
      Icons.check_circle_rounded, // Thorough Screening
      Icons.flash_on_rounded, // Quick Response
      Icons.description_rounded, // Transparent Reporting
      Icons.center_focus_strong_rounded, // Market Expertise
      Icons.favorite_rounded, // Customer First
    ];

    // Responsive header sizes
    final titleSize = w >= 1100 ? 34.0 : (w >= 700 ? 30.0 : 26.0);
    final subtitleSz = w >= 700 ? 18.0 : 16.0;

    return MediaQuery(
      data: clamped,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B0B0B), Color(0xFF14110C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                // ---- Header ----
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2112),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'WHY CHOOSE US',
                    style: TextStyle(
                      color: const Color(0xFFD6A84B),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'What Sets Us Apart',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Experience the difference with our professional, transparent, and client-focused approach to property management',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: subtitleSz,
                      height: 1.45,
                      color: const Color(0xFFB8B8B8), // gray-600
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ---- Grid ----
                LayoutBuilder(
                  builder: (context, c) {
                    int cross = 1;
                    if (c.maxWidth >= 1100) {
                      cross = 4;
                    } else if (c.maxWidth >= 700) {
                      cross = 2;
                    }

                    // Stable card heights per breakpoint to prevent overflow
                    final bool useCircularCards = cross == 4;

                    final double cardHeight = useCircularCards
                        ? 240
                        : switch (cross) {
                            2 => 180,
                            _ => 200,
                          };

                    // Allow a bit more copy on phones where columns = 1
                    final int descLines = switch (cross) {
                      4 => 5,
                      2 => 4,
                      _ => 5,
                    };

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: whyUsData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cross,
                        mainAxisExtent: cardHeight,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, i) {
                        final item = whyUsData[i];
                        final icon = icons[i % icons.length];

                        return _WhyTile(
                          icon: icon,
                          title: item.title,
                          description: item.description,
                          descMaxLines: descLines,
                          isCircular: useCircularCards,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WhyTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final int descMaxLines;
  final bool isCircular;

  const _WhyTile({
    required this.icon,
    required this.title,
    required this.description,
    this.descMaxLines = 3,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 6,
      shape: isCircular
          ? const CircleBorder()
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircular ? null : BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF5A431E)),
          boxShadow: AppShadows.soft,
        ),
        padding: EdgeInsets.all(isCircular ? 28 : 18),

        child: Column(
          mainAxisAlignment: isCircular
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          crossAxisAlignment: isCircular
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            // icon badge
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2A2112),
                shape: BoxShape.circle,
              ),

              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: const Color(0xFFD6A84B), size: 24),
            ),
            const SizedBox(height: 10),

            // Title kept to 2 lines to avoid overflow at small widths
            Text(
              title,
              textAlign: isCircular ? TextAlign.center : TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),

            // Description line-clamped so card height stays stable
            Expanded(
              child: Text(
                description,
                textAlign: isCircular ? TextAlign.center : TextAlign.start,
                maxLines: descMaxLines,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFB8B8B8),
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
