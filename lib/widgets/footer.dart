import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

const Color _gold = Color(0xFFD6A84B);
const Color _lightGold = Color(0xFFFFD978);
const Color _deepGold = Color(0xFF8F641A);
const Color _cream = Color(0xFFF1E9D8);
const Color _mutedCream = Color(0xFFC8BFAF);
const Color _deepBlack = Color(0xFF080808);
const Color _charcoal = Color(0xFF151515);

class SiteFooter extends StatelessWidget {
  const SiteFooter({
    super.key,
    this.onTapItem,
    this.onOpenPrivacy,
    this.onOpenTerms,
    this.onOpenCookie,
  });

  final void Function(String id)? onTapItem;
  final VoidCallback? onOpenPrivacy;
  final VoidCallback? onOpenTerms;
  final VoidCallback? onOpenCookie;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_deepBlack, Color(0xFF121212), Color(0xFF0B0B0B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          top: BorderSide(color: _gold.withOpacity(0.7), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Main footer columns
              LayoutBuilder(
                builder: (context, constraints) {
                  const gap = 20.0;

                  int columns = 1;

                  if (constraints.maxWidth >= 1100) {
                    columns = 4;
                  } else if (constraints.maxWidth >= 800) {
                    columns = 3;
                  } else if (constraints.maxWidth >= 600) {
                    columns = 2;
                  }

                  final itemWidth =
                      (constraints.maxWidth - (columns - 1) * gap) / columns;

                  return Wrap(
                    spacing: gap,
                    runSpacing: 28,
                    children: [
                      SizedBox(width: itemWidth, child: const _BrandBlock()),
                      SizedBox(
                        width: itemWidth,
                        child: _QuickLinksBlock(onTapItem: onTapItem),
                      ),
                      SizedBox(width: itemWidth, child: const _ServicesBlock()),
                      SizedBox(width: itemWidth, child: const _ContactBlock()),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              Divider(color: _gold.withOpacity(0.3), height: 1),

              // Contact information row
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 900;

                    const information = [
                      _InfoRow(
                        icon: Icons.location_on_rounded,
                        title: 'Address',
                        text:
                            'Mirabella Complex, Gulshan-e-Sahat, E-18\nIslamabad, Pakistan',
                      ),
                      _InfoRow(
                        icon: Icons.phone_rounded,
                        title: 'Phone',
                        text: '+923300492037',
                      ),
                      _InfoRow(
                        icon: Icons.mail_outline_rounded,
                        title: 'Email',
                        text: 'info@mirabellaestatemanagementservices.com',
                      ),
                    ];

                    if (isWide) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: information
                            .map(
                              (item) => Flexible(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 420,
                                  ),
                                  child: item,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }

                    return Wrap(
                      spacing: 12,
                      runSpacing: 20,
                      children: information
                          .map(
                            (item) => ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: item,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),

              Divider(color: _gold.withOpacity(0.3), height: 1),

              const SizedBox(height: 18),

              // Copyright and legal links
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 800;

                  final legalLinks = Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 18,
                    runSpacing: 8,
                    children: [
                      _legalLink(
                        context,
                        label: 'Privacy Policy',
                        onTap: onOpenPrivacy,
                        fallbackRoute: '/privacy-policy',
                      ),
                      _legalLink(
                        context,
                        label: 'Terms of Service',
                        onTap: onOpenTerms,
                        fallbackRoute: '/terms-of-service',
                      ),
                      _legalLink(
                        context,
                        label: 'Cookie Policy',
                        onTap: onOpenCookie,
                        fallbackRoute: '/cookie-policy',
                      ),
                    ],
                  );

                  final copyright = Text(
                    '© ${DateTime.now().year} MEMS. All rights reserved.',
                    style: const TextStyle(color: _mutedCream, fontSize: 12),
                  );

                  if (isWide) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: copyright),
                        const SizedBox(width: 12),
                        legalLinks,
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      copyright,
                      const SizedBox(height: 12),
                      legalLinks,
                    ],
                  );
                },
              ),

              const SizedBox(height: 14),

              const Text(
                'Licensed Real Estate Management Company',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF817A6E),
                  fontSize: 11,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _legalLink(
    BuildContext context, {
    required String label,
    required VoidCallback? onTap,
    required String fallbackRoute,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        hoverColor: _gold.withOpacity(0.08),
        splashColor: _gold.withOpacity(0.15),
        onTap: () async {
          if (onTap != null) {
            onTap();
            return;
          }

          try {
            await Navigator.of(context).pushNamed(fallbackRoute);
            return;
          } catch (_) {
            await launchUrlString(
              fallbackRoute,
              mode: LaunchMode.externalApplication,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
          child: Text(
            label,
            style: const TextStyle(
              color: _gold,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandBlock extends StatelessWidget {
  const _BrandBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_lightGold, _gold, _deepGold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: _gold.withOpacity(0.2),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.apartment_rounded,
                color: Colors.black,
                size: 28,
              ),
            ),

            const SizedBox(width: 10),

            const Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mirabella',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Estate Management Services',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: _gold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        const Text(
          'Professional property management services in Islamabad and Rawalpindi. '
          'We help property owners maximize returns while minimizing stress through expert management solutions.',
          style: TextStyle(color: _mutedCream, height: 1.55),
        ),
      ],
    );
  }
}

class _QuickLinksBlock extends StatelessWidget {
  const _QuickLinksBlock({this.onTapItem});

  final void Function(String id)? onTapItem;

  @override
  Widget build(BuildContext context) {
    return _LinkListBlock(
      title: 'Quick Links',
      items: [
        _LinkItem(text: 'Home', onTap: () => onTapItem?.call('home')),
        _LinkItem(text: 'Services', onTap: () => onTapItem?.call('services')),
        _LinkItem(text: 'Pricing', onTap: () => onTapItem?.call('pricing')),
        _LinkItem(text: 'Contact', onTap: () => onTapItem?.call('contact')),
      ],
    );
  }
}

class _ServicesBlock extends StatelessWidget {
  const _ServicesBlock();

  @override
  Widget build(BuildContext context) {
    const services = [
      'Property Management',
      'Rental Services',
      'Maintenance',
      'Tenant Relations',
      'Financial Management',
      'Legal Services',
    ];

    return _LinkListBlock(
      title: 'Our Services',
      items: services
          .map((service) => _LinkItem(text: service, onTap: () {}))
          .toList(),
    );
  }
}

class _LinkListBlock extends StatelessWidget {
  final String title;
  final List<_LinkItem> items;

  const _LinkListBlock({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _gold,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 10),

        ...items.map(
          (item) => Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(6),
              hoverColor: _gold.withOpacity(0.08),
              splashColor: _gold.withOpacity(0.15),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                child: Text(
                  item.text,
                  softWrap: true,
                  style: const TextStyle(color: _mutedCream, height: 1.3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LinkItem {
  final String text;
  final VoidCallback onTap;

  const _LinkItem({required this.text, required this.onTap});
}

class _ContactBlock extends StatelessWidget {
  const _ContactBlock();

  @override
  Widget build(BuildContext context) {
    const linkStyle = TextStyle(
      color: _gold,
      fontWeight: FontWeight.w700,
      height: 1.4,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact',
          style: TextStyle(
            color: _gold,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 10),

        _contactRow(
          icon: Icons.place_rounded,
          child: const Text(
            'Mirabella Complex, Gulshan-e-Sahat, E-18\nIslamabad, Pakistan',
            style: TextStyle(color: _mutedCream, height: 1.5),
          ),
        ),

        const SizedBox(height: 8),

        _contactRow(
          icon: Icons.phone_rounded,
          child: InkWell(
            onTap: () {
              launchUrlString('tel:+923300492037');
            },
            child: const Text('+923300492037', style: linkStyle),
          ),
        ),

        const SizedBox(height: 8),

        _contactRow(
          icon: Icons.mail_outline_rounded,
          child: InkWell(
            onTap: () {
              launchUrlString(
                'mailto:info@mirabellaestatemanagementservices.com',
              );
            },
            child: const Text(
              'info@mirabellaestatemanagementservices.com',
              softWrap: true,
              style: linkStyle,
            ),
          ),
        ),
      ],
    );
  }

  static Widget _contactRow({required IconData icon, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.only(top: 1), child: SizedBox()),
        Icon(icon, color: _gold, size: 20),
        const SizedBox(width: 8),
        Expanded(child: child),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;

  const _InfoRow({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: _gold, size: 18),

            const SizedBox(width: 8),

            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          text,
          softWrap: true,
          style: const TextStyle(color: _mutedCream, fontSize: 12, height: 1.5),
        ),
      ],
    );
  }
}
