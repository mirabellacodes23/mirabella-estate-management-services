// ===============================
// File: lib/screens/home/services_section.dart
// Services grid (8 cards) + section header (responsive + overflow-proof)
// ===============================
import 'package:flutter/material.dart';

import '../../constants/tokens.dart';
import '../../data/data.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;

    // Prevent giant text scale from blowing up the layout
    final clamped = mq.copyWith(
      textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2),
    );

    final serviceIcons = <IconData>[
      Icons.apartment_rounded, // Residential Property Management
      Icons.work_rounded, // Commercial Property Management
      Icons.vpn_key_rounded, // Rental & Leasing
      Icons.build_rounded, // Maintenance & Repairs
      Icons.people_alt_rounded, // Tenant Relations
      Icons.bar_chart_rounded, // Financial Management
      Icons.description_rounded, // Legal & Compliance
      Icons.settings_suggest_rounded, // Property Consulting
    ];

    // Responsive header sizes
    final subSize = w >= 700 ? 18.0 : 16.0;

    return MediaQuery(
      data: clamped,
      child: Container(
        color: const Color(0xFF0B0B0B),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                // ---- Header ----
                const _SectionHeader(),
                const SizedBox(height: 12),
                Text(
                  'From residential to commercial properties, we offer complete management services designed to maximize your returns and minimize your stress',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: subSize,
                    height: 1.45,
                    color: const Color(0xFFB8B8B8),
                  ),
                ),
                const SizedBox(height: 28),

                // ---- Grid ----
                LayoutBuilder(
                  builder: (context, c) {
                    int cross = 1;
                    if (c.maxWidth >= 1100) {
                      cross = 4;
                    } else if (c.maxWidth >= 760) {
                      cross = 2;
                    }

                    // Taller cards on phones → more room for text/features
                    final double cardHeight = switch (cross) {
                      4 => 320, // desktop
                      2 => 350, // tablet
                      _ => 400, // phone
                    };

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: servicesData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cross,
                        mainAxisExtent: cardHeight,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemBuilder: (context, i) {
                        final s = servicesData[i];
                        final icon = serviceIcons[i % serviceIcons.length];

                        return _ServiceCard(
                          icon: icon,
                          title: s.title,
                          description: s.description,
                          features: s.features,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF171717),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFD6A84B),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.payments_rounded,
                            color: Color(0xFFD6A84B),
                            size: 30,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Flexible Payment Plans',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Convenient payment options designed to make property transactions more manageable.',
                        style: TextStyle(
                          color: Color(0xFFB8B8B8),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: const [
                          _PaymentPlanTile(
                            number: '01',
                            text: '50% advance, remaining 50% within one month',
                          ),
                          _PaymentPlanTile(
                            number: '02',
                            text: 'Six instalments with two quarterly payments',
                          ),
                          _PaymentPlanTile(
                            number: '03',
                            text:
                                '50% booking, remaining 50% in four quarterly payments (PKR 5M each)',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '* Terms and conditions apply',
                        style: TextStyle(
                          color: Color(0xFFD6A84B),
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final titleSize = w >= 1100 ? 34.0 : (w >= 700 ? 30.0 : 26.0);

    return Column(
      children: [
        // Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2112), // blue-100
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'WHAT MEMS PROVIDES',
            style: TextStyle(
              color: Color(0xFFD6A84B),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Comprehensive Property Management Solutions',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final List<String> features;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -6.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hovered ? const Color(0xFFD6A84B) : const Color(0xFF3A3020),
            width: _hovered ? 2 : 1,
          ),
          boxShadow: _hovered ? AppShadows.medium : AppShadows.soft,
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // icon badge
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD6A84B), Color(0xFF9C6B18)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(
                widget.icon,
                color: const Color(0xFF111111),
                size: 28,
              ),
            ),
            const SizedBox(height: 12),

            // Title (safe-wrap)
            Text(
              widget.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 6),

            // Description clamped to avoid pushing features off-card on phones
            Text(
              widget.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Color(0xFFB8B8B8), // gray-500/600
              ),
            ),
            const SizedBox(height: 10),

            // Features fill the remaining space safely
            Expanded(
              child: ListView.separated(
                itemCount: widget.features.length,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, i) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2.0),
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: Color(0xFFD6A84B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.features[i],
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            color: Color(0xFFE5E5E5),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentPlanTile extends StatelessWidget {
  final String number;
  final String text;

  const _PaymentPlanTile({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3020)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2112),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFFD6A84B),
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFFE5E5E5),
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
